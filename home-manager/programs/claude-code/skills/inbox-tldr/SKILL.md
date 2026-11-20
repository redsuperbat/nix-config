---
name: inbox-tldr
description: Read unread Gmail and give a short report of what needs attention, what is worth knowing and what is noise. Optionally mark everything read afterwards
disable-model-invocation: true
---

Extra instructions (optional):

$ARGUMENTS

1. Search only unread mail: `search_threads` with `is:unread in:inbox -category:promotions -category:social`, `view: THREAD_VIEW_SUMMARY`, `pageSize: 50`. Page through `nextPageToken` until done. Don't widen to read mail unless asked.
2. Sort threads by sender and subject into groups before reading bodies. Automated mail (notifications, alerts, receipts, login codes, newsletters) is usually clear from the snippet. Collapse each kind into one line.
3. Open with `get_thread` only threads where the snippet isn't enough: mail from people, repeated alerts, requests for your approval or review. Use `MINIMAL` for repeated automated threads. Reading a thread does not mark it read.
4. Connect related mail instead of listing it one by one:
   - Match requests with their outcomes (approval request vs. approved, alert fired vs. resolved). Flag requests with no outcome as possibly still open.
   - Note mail that arrived close together and may be about the same event. Say "may be connected" unless you checked.
   - Separate mail that asks you to act from mail that only reports something done.
5. Report in this order, short bullets, with links where the mail has them:
   - **Needs your attention**: approvals, review requests, mail from people that asks something, things to read. Give each one a concrete **Action**.
   - **Worth knowing**: alerts, merges, FYIs.
   - **Safe to ignore**: one line naming the noise.
   End with one offer of a useful follow-up (for example, look up an alert's cause in the logs).
6. Don't change mail state unless asked. If asked to mark all as read: run `unlabel_thread` with `["UNREAD"]` on every thread id from step 1, all in parallel, then run the step 1 search again and confirm it returns nothing. "Mark as unread" on mail that is already unread is a no-op: say so and ask whether "read" was meant.
