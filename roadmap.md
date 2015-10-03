

This is not a comprehensive list of Laddr changes; it "just" captures a group of specific problems that a group of Code for Philly regular attendees & staff identified as causing "friction" for new attendees trying to get started.
We'd like to grow it into a more comprehensive plan, with every bullet point linked to an Issue to be worked individually.

It's a growing doc; please propose changes, talk on the Laddr slack about this, etc. Thanks!


- [ ] General display isssues:
    - [ ] Text on confirmation pages (ie: created a new project update) is cut off at top
    - [ ] Placeholder bullet point as a reminder that there are other CSS issues to be identified & resolved.

- [ ] Changes to Members
    - [ ] Move the “Members” sidebar to /people
    - [X] (CfP only?) Fix the grid display issue
     
- [ ] Changes to Projects Page (https://codeforphilly.org/projects)
     - [ ] Move the “Projects” sidebar from the front page to /projects so projects navigation is all in one place (see: Code for Charlotte)
     - [ ] Sort the Stages list - ie, Commenting, then Prototyping, etc.
     - [ ] Possibly rename a Stage or two - are they all as clear as possible? Research needed.
          - [ ] At the very least include descriptions, which are already somewhere in the code
     - [ ] Ability to sort projects by latest activity (#74)
          - [ ] Activity is: Check-ins; new member joined; update made; github commit made #73
     - [ ] Display tags under/alongside each project
     - [ ] Display Stage under/alongside each project


- [ ] Changes to individual project pages (ex: https://codeforphilly.org/projects/Solar_Sunflower)
     - [ ] List tags!
     - [ ] Stage “status bar” should grow!
     - [ ] List Founders/Maintainers before other project members, so it’s more clear who an interested party can contact

- [ ] Changes to check-in process
     - [ ] The “Upcoming Meetups” list can get awfully crowded if organizers are setting them up well in advance. It should probably just show the next event, not all future events.
     - [ ] During meetups, when the “check-in” button is active, it shouldn’t be in one little corner - it should take over the big above-the-fold banner area.
     - [ ] Attendees shouldn’t have to go through a full account-creation process just to say they were present; it’s too big a barrier.
          - [ ] Let people check in just by typing in the following, into nice big friendly boxes:
               * Name
               * Email
               * Project (or none!)
               * Checkbox for newsletter opt-in
            * Presumably this means creating some kind of “unathenticated” account for them under the hood so if/when they create a full account, we can tie their activity back.

- [ ] Other changes
     - [ ] Search results should be re-ordered to return projects before people, since that’s the more common case.

* New Feature Ideas (not fully baked)
     * A Help Wanted flag for projects, maybe per-tag, to help people find stuff that wants love?
     * Break Commenting stage for projects out into a new Ideas section, to keep Projects limited to things that have some work done?
     * Would be great if users could star/upvote projects to follow their updates, help identify which Ideas have momentum/interest.
