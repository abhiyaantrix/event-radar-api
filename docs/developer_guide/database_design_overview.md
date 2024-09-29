# Database Design Overview

This database is designed to support a multi-purpose event management platform where users can create, manage,
and attend events. This document outlines core entities involved in the platform and their relationships.
The initial design focuses on supporting individual events, while future enhancements can extend the design
to accommodate event groups (like conferences, fairs, etc.).

To understand different concepts and entities, check this [High-level entities description](../user_guide/entities.md)
and for architectural decisions, check this [Architectural overview document](./architecture_overview.md).

## Entities Overview

### Users

**users** table stores user account information such as names, email, preferences, etc. along with their roles
as participants, organizers, and administrators on the platform. A user can take on different roles depending
on their interactions with the platform.

### Groups

**groups** table defines user groups within the platform. Groups are created and managed by users, typically
representing a community or organization. Organizers from a group can create events, and members can participate
in events organized by the group.

### Group Memberships

**group_memberships** table manages the many-to-many relationship between users and groups.
This allows users to join multiple groups and groups to have multiple members.
Each member will have member role by default and separately can have a group admin role.

### Events

**events** table stores all information related to individual events. Each event has an organizer (a user or group),
a start and end time, and details about the event itself. Events can have online and/or offline meeting.

- **Online**: Events that occur virtually
- **Offline**: In-person events that require a physical location
- **Hybrid**: Events that have both online and offline meetings associated are considered as hybrid events

#### Meetings

**online_meetings** table stores details for online events, including the URL of the virtual meeting
and the platform being used (e.g., Zoom, Google Meet). Each online meeting is associated with a single event.

**offline_meetings** table stores details for offline, in-person events. It includes fields for the physical address,
city, and other relevant location data. Each offline meeting is associated with a single event.

### Attendees

**attendees** table tracks users who attend individual events. Each entry is linked to both a user and an event.

There is a status of attendance

- Confirmed: Attendance is confirmed and user will be allowed to attend the event.
- Withdrawn: User withdraws their attendance from the event, their seat can then be alloted to someone else.
- Rejected: Organizer/Admin rejected user's attendance for the event for specific reason.

## Future extensions

This section outlines potential enhancements and features that could be implemented in future iterations
of the system to expand its functionality and improve user experience.

### Customizable attendance workflows

Initial attendance management workflow is kept simpler.
Though it can further be extended to support advanced flows with multiple statuses.

1. Pending confirmation: An email is sent to user and the user needs to confirm their attendance by clicking the link,
   there will be a time frame within which user needs to confirm attendance
   else it will be given to next user on waiting list.
2. Pending approval: For more restrictive events, admin/organizer can optionally decide to exclusively confirm attendance.
3. On waiting list: For events with limited seats to support waiting list.
4. Attended: To record whether the user actually attended the event or not.
   It can even be automatically done for virtual meetings.

Additionally, organizers can tailor the attendance process to suit their needs. Organizer can enable disable different
feature such enable waiting list, users must confirm attendance, disable withdrawal feature, etc.
This could be a separate table named `event_settings`. This flexibility can ensure that both informal events
with open attendance and more restrictive, capacity-limited events can coexist on the platform with minimal friction.

### Larger Events

In the future, the design can be extended to support larger event structures, such as conferences, fairs,
and other event groups that consist of multiple smaller events.

#### Event Groups

- **Event Groups**: In addition to individual events, we can introduce the concept of event groups
  (e.g., conferences, conventions), where each group consists of multiple related events.
  This can be done by creating an `event_groups` table that stores information about these larger entities.
- **Relationship with Events**: Each event can be part of an event group. This can be managed by adding a foreign key
  relationship between the `event_groups` and `events` tables, which allows for a parent-child hierarchy.
- **Group Event Attendees**: Just like individual events have attendees, event groups (conferences, etc.)
  can have their own attendees. A new `event_group_attendees` table would track users who register
  for the entire event group, allowing them to participate in multiple sub-events.

For example, a `Tech Conference` could contain several smaller events like `Keynote Speech`, `Workshop 1`,
`Workshop 2`, etc. Users register for the conference and then individually register for separate events
organized in the conference.
