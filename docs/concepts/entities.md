# Entities Overview

## User

**User** is the central entity of the application. A user represents an individual who can sign up to the platform
to participate in various activities like attending events, create and join groups, and organize events.

User can choose to keep their details private or public while attending the events.

## Event

**Event** represents a gathering or activity that users can organize or attend. Events can be online, offline, or hybrid,
and they may be free or require payment to attend. Each event has important details such as the time, location,
description, and price (if applicable).

- Users can create events
- Events can have multiple organizers
- Events can have limited or unlimited seats
- Events can be tagged as online, offline, or hybrid
- Users can register for events and manage their attendance
- Events can be free or paid, with integration for secure payments
- Can optionally belong a Group

## Group

**Group** is a community within the application where users with similar interests can come together. Groups provide
a space for users to discuss, share ideas, and organize events related to the group's focus. Users can join multiple
groups to stay connected with topics or activities they care about.

- Groups are created by users and centered around shared interests
- Members can join groups to receive notifications about upcoming events and discussions
- Group administrators can create and manage events related to the group, approve group members
- Groups help in organizing discussions and participation around common interests

## Event Registration

**Event Registration** is the process through which users sign up to attend an event. When a user registers for an event,
they receive confirmation and relevant event details. For paid events, users must complete payment
during the registration process.

- Users can register for both free and paid events
- There could be waiting list for events with limited seats
- Event organizers can manage the list of attendees, accept or reject application to attend
- Users receive event details and reminders after registration

## Organizer

**Organizer** is a user who creates and manages events. Multiple organizers can be associated with a single event,
allowing collaborative event management. Organizers have administrative control over their events, including setting
event details, managing attendees, and making changes as needed.

- Organizers create and manage events
- Events can have multiple organizers to share management responsibilities
- Organizers can edit event details and oversee registrations
