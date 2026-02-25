How Horizontal Swipe Was Implemented

Horizontal swipe is handled by:

TabBarView(
  controller: _tabController,
  children: [...]
)

TabBarView provides built-in horizontal gesture detection.

It is synced with TabBar using the same TabController.

Horizontal swiping only switches tabs.

It does not control vertical scrolling.

2️⃣ Who Owns the Vertical Scroll (and Why)
✅ The ONLY vertical scroll owner is:

NestedScrollView

Why:

The screen must behave like a single continuous scroll.

The collapsible header + pinned tab bar must scroll together.

Pull-to-refresh must work from any tab.

Switching tabs must not reset scroll position.

Inner product lists use:

NeverScrollableScrollPhysics()

This prevents multiple vertical scrollables and avoids:

Scroll conflicts

Gesture competition

Jitter

Scroll jumps

3️⃣ Trade-offs / Limitations of This Approach
✅ Advantages

Smooth coordinated scrolling

Sticky tab works correctly

No gesture conflicts

Scroll position preserved across tabs

Pull-to-refresh works globally

⚠️ Trade-offs

Inner lists cannot scroll independently

All vertical movement is controlled by NestedScrollView.

More complex than simple ListView

Requires Sliver understanding.

Pagination needs careful implementation

Infinite scroll must be triggered via the parent scroll controller.

Heavy UI inside tabs may affect performance

Since all content participates in one scroll pipeline.

Approach Was Chosen

Instead of forcing multiple scrollables (which causes jitter and broken gestures), this design:

Respects Flutter’s scroll architecture

Uses Slivers correctly

Keeps gesture ownership explicit

Avoids fragile hacks

It is scalable and production-safe.
