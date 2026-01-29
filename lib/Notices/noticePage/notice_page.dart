import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Bloc/notice_bloc.dart';
import '../Bloc/notice_event.dart';
import '../Bloc/notice_state.dart';
import '../Notification_service/firebase_notification_services.dart';

enum DateFilter { all, today, thisWeek, thisMonth, custom }

class NoticePage extends StatefulWidget {
  final String userId;
  final String role;

  const NoticePage({required this.userId, required this.role, super.key});

  @override
  State<NoticePage> createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage>
    with AutomaticKeepAliveClientMixin {
  DateFilter _selectedFilter = DateFilter.all;
  DateTime? _customStartDate;
  DateTime? _customEndDate;
  List<dynamic> _filteredNotices = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NoticeBloc>().add(FetchNotices());
    });
  }

  void _filterNotices(List<dynamic> notices) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final thisWeekStart = today.subtract(Duration(days: now.weekday - 1));
    final thisMonthStart = DateTime(now.year, now.month, 1);

    if (mounted) {
      setState(() {
        switch (_selectedFilter) {
          case DateFilter.all:
            _filteredNotices = notices;
            break;
          case DateFilter.today:
            _filteredNotices = notices.where((notice) {
              final noticeDate = DateTime(
                notice.timestamp.year,
                notice.timestamp.month,
                notice.timestamp.day,
              );
              return noticeDate.isAtSameMomentAs(today);
            }).toList();
            break;
          case DateFilter.thisWeek:
            _filteredNotices = notices.where((notice) {
              return notice.timestamp.isAfter(thisWeekStart) ||
                  notice.timestamp.isAtSameMomentAs(thisWeekStart);
            }).toList();
            break;
          case DateFilter.thisMonth:
            _filteredNotices = notices.where((notice) {
              return notice.timestamp.isAfter(thisMonthStart) ||
                  notice.timestamp.isAtSameMomentAs(thisMonthStart);
            }).toList();
            break;
          case DateFilter.custom:
            if (_customStartDate != null && _customEndDate != null) {
              final startDate = DateTime(
                _customStartDate!.year,
                _customStartDate!.month,
                _customStartDate!.day,
              );
              final endDate = DateTime(
                _customEndDate!.year,
                _customEndDate!.month,
                _customEndDate!.day,
                23,
                59,
                59,
              );
              _filteredNotices = notices.where((notice) {
                final ts = notice.timestamp;
                return (ts.isAfter(startDate) ||
                        ts.isAtSameMomentAs(startDate)) &&
                    (ts.isBefore(endDate) || ts.isAtSameMomentAs(endDate));
              }).toList();
            } else {
              _filteredNotices = notices;
            }
            break;
        }
      });
    }
  }

  Future<void> _selectCustomDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      currentDate: DateTime.now(),
      initialDateRange: _customStartDate != null && _customEndDate != null
          ? DateTimeRange(start: _customStartDate!, end: _customEndDate!)
          : null,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF10B981),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF1E293B),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && mounted) {
      setState(() {
        _customStartDate = picked.start;
        _customEndDate = picked.end;
        _selectedFilter = DateFilter.custom;
      });
      final currentState = context.read<NoticeBloc>().state;
      if (currentState is NoticeLoaded) {
        _filterNotices(currentState.notices);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: BlocConsumer<NoticeBloc, NoticeState>(
          listener: (context, state) {
            if (state is NoticeLoaded && mounted) {
              _filterNotices(state.notices);
            }
          },
          builder: (context, state) {
            if (state is NoticeLoading) {
              return _buildLoadingState();
            } else if (state is NoticeLoaded) {
              if (_filteredNotices.isEmpty) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildHeader(),
                      _buildFilterSection(),
                      _buildEmptyState(),
                    ],
                  ),
                );
              }
              return _buildNoticesList(_filteredNotices);
            } else if (state is NoticeError) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    _buildHeader(),
                    _buildErrorState(state.message),
                  ],
                ),
              );
            }
            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(),
                  _buildLoadingState(),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: widget.role == 'admin'
          ? FloatingActionButton.extended(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
              onPressed: () {
                context.push('/add_notice?adminId=${widget.userId}');
              },
              icon: const Icon(Icons.add),
              label: Text(
                "Create Notice",
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                ),
              ),
              elevation: 8,
              heroTag: "add_notice_${widget.userId}", // Unique hero tag
            )
          : null,
    );
  }

  Widget _buildHeader() {
    final width = MediaQuery.of(context).size.width;
    bool isDesktop = width > 600;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          (widget.role != 'student' && isDesktop)
              ? Container()
              : IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 22,
                  ),
                ),
          Text(
            _getNoticesTitle(),
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1E293B),
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "${_filteredNotices.length} notices",
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    final width = MediaQuery.of(context).size.width;
    bool isDesktop = width > 600;

    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.filter_list,
                color: Color(0xFF10B981),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                "Filter Notices",
                style: GoogleFonts.nunitoSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E293B),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  context.read<NoticeBloc>().add(FetchNotices());
                },
                icon: const Icon(
                  Icons.refresh,
                  size: 23,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildFilterChip("All", DateFilter.all, isDesktop),
              _buildFilterChip("Today", DateFilter.today, isDesktop),
              _buildFilterChip("This Week", DateFilter.thisWeek, isDesktop),
              _buildFilterChip("This Month", DateFilter.thisMonth, isDesktop),
              _buildCustomDateChip(isDesktop),
            ],
          ),
          if (_selectedFilter == DateFilter.custom &&
              _customStartDate != null &&
              _customEndDate != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.date_range,
                    color: Color(0xFF10B981),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "${DateFormat('MMM dd, yyyy').format(_customStartDate!)} - ${DateFormat('MMM dd, yyyy').format(_customEndDate!)}",
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF10B981),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, DateFilter filter, bool isDesktop) {
    final isSelected = _selectedFilter == filter;
    return GestureDetector(
      onTap: () {
        if (mounted) {
          setState(() {
            _selectedFilter = filter;
          });

          final currentState = context.read<NoticeBloc>().state;
          if (currentState is NoticeLoaded) {
            _filterNotices(currentState.notices);
          } else {
            context.read<NoticeBloc>().add(FetchNotices());
          }
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 14 : 10, vertical: isDesktop ? 7 : 5),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF10B981) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ?  Color(0xFF10B981) : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.nunitoSans(
            fontSize: isDesktop ? 16 : 10,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white :  Color(0xFF64748B),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomDateChip(bool isDesktop) {
    final isSelected = _selectedFilter == DateFilter.custom;
    return GestureDetector(
      onTap: _selectCustomDateRange,
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 16 : 10, vertical: isDesktop ? 8 : 5),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF10B981) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF10B981) : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.date_range,
              size: isDesktop ? 16 : 10,
              color: isSelected ? Colors.white : const Color(0xFF64748B),
            ),
            const SizedBox(width: 4),
            Text(
              "Custom",
              style: GoogleFonts.inter(
                fontSize: isDesktop ? 16 : 10,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
              strokeWidth: 3,
            ),
            const SizedBox(height: 24),
            Text(
              "Loading notices...",
              style: GoogleFonts.inter(
                fontSize: 16,
                color: const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final hasActiveFilter = _selectedFilter != DateFilter.all;
    return Container(
      padding: const EdgeInsets.all(60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withOpacity(0.1),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              hasActiveFilter
                  ? Icons.filter_list_off
                  : Icons.notifications_none,
              size: 48,
              color: const Color(0xFF10B981),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            hasActiveFilter ? "No notices found" : "No notices yet",
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            hasActiveFilter
                ? "Try adjusting your filter settings"
                : "Create your first notice to get started",
            style: GoogleFonts.inter(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          if (hasActiveFilter) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (mounted) {
                  setState(() {
                    _selectedFilter = DateFilter.all;
                    _customStartDate = null;
                    _customEndDate = null;
                  });

                  final currentState = context.read<NoticeBloc>().state;
                  if (currentState is NoticeLoaded) {
                    _filterNotices(currentState.notices);
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "Clear Filter",
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Container(
      padding: const EdgeInsets.all(60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "Something went wrong",
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: GoogleFonts.inter(
              fontSize: 16,
              color: const Color(0xFF64748B),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<NoticeBloc>().add(FetchNotices());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              "Retry",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoticesList(List<dynamic> notices) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: _buildHeader(),
        ),
        SliverToBoxAdapter(
          child: _buildFilterSection(),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 20),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final notice = notices[index];
              return Column(
                children: [
                  _buildNoticeCard(notice, index),
                  if (index < notices.length - 1)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      height: 1,
                      width: double.infinity,
                      color: Colors.grey.shade300,
                    ),
                ],
              );
            },
            childCount: notices.length,
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 80),
        ),
      ],
    );
  }

  String _getNoticesTitle() {
    switch (_selectedFilter) {
      case DateFilter.all:
        return "All Notices";
      case DateFilter.today:
        return "Today's Notices";
      case DateFilter.thisWeek:
        return "This Week's Notices";
      case DateFilter.thisMonth:
        return "This Month's Notices";
      case DateFilter.custom:
        return "Filtered Notices";
    }
  }

  Widget _buildNoticeCard(dynamic notice, int index) {
    final hasSeen = notice.seenBy.contains(widget.userId);
    if (!hasSeen && (widget.role == 'teacher' || widget.role == 'student')) {
      context.read<NoticeBloc>().add(
        MarkNoticeSeen(noticeId: notice.id, userId: widget.userId),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: hasSeen ? null : Border.all(
          color: Colors.grey.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            if (mounted) {
              GoRouter.of(context).pushNamed('notice_card', queryParameters: {
                'title': notice.title,
                'description': notice.description,
                'view': notice.seenBy.length.toString(),
                'date': DateFormat('MMM dd, yyyy • hh:mm a').format(notice.timestamp)
              });
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [

                    Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.campaign_rounded,
                            color: Colors.green.shade700,
                            size: 18,
                          ),
                        ),
                        if (!hasSeen && (widget.role == 'teacher' || widget.role == 'student'))
                          Positioned(
                            right: -1,
                            top: -1,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 1.5),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  notice.title,
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade800,
                                    height: 1.2,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (!hasSeen && (widget.role == 'teacher' || widget.role == 'student')) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    "NEW",
                                    style: GoogleFonts.inter(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (widget.role == 'admin') ...[
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                          padding: const EdgeInsets.all(6),
                          onPressed: () => {
                            showDialog(context: context, builder: (context) {
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                title: Text('Delete Notice', style: GoogleFonts.inter(textStyle: TextStyle(
                                  color: Colors.grey.shade800,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ))),
                                content: Text('Are you sure you want to delete this notice?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      FirebaseNoticeService().deleteNotice(notice.id);
                                      Navigator.of(context).pop();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Notice deleted successfully!'),
                                            backgroundColor: Colors.green,
                                          ));
                                      context.read<NoticeBloc>().add(FetchNotices());
                                    },
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                    ),
                                    child: Text('Delete'),

                                  )


                                ],
                              );
                            }
                            ),

                          },

                          icon: Icon(
                            Icons.delete_outline_rounded,
                            color: Colors.red.shade600,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.visibility_rounded,
                            size: 12,
                            color: Colors.green.shade700,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${notice.seenBy.length}",
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.green.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    // Date
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          size: 12,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 4),
                        Text(
    DateFormat('MMM dd, yyyy • hh:mm a').format(notice.timestamp),
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
