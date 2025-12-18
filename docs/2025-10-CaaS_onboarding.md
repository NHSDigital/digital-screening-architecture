# Onboarding Screening to CaaS

**James Darling, Head of Technology - Digital Screening**

Cohorting as a Service (CaaS) is the agreed strategic solution for cohorting across the 6 adult screening pathways. We have just gone live with onboarding Breast onto CaaS. This document outlines the work required to onboard the remaining 5, and the order we will do it in.

This paper is an expansion on the "[Digital Screening and Cohorting as a Service](https://nhs-my.sharepoint.com/:w:/g/personal/james_darling1_nhs_net/EZqEQCbDmRVHl13B2QUm0d0BUu8Lxq9YpLKEywUxCMH5DQ?e=BGlkMH)" paper, which outlines the scope of what we mean when we say "cohorting".

1\. Complete Breast Migration
-----------------------------

- **When**: Q3 2025
- **Teams**: Breast Select

By the time you are reading this, we should have switched breast cohorting from Population Index (PI) to CaaS/Cohort Manager. There will be some tidying up work, like shutting down the PI feeds.

2\. Discovery in migrating away from Current Posting
----------------------------------------------------

- **When**: Q3 2025
- **Teams**: Breast Select, CaaS

We currently determine residency in England based on the legacy and deprecated 'nhais_current_posting' field in Personal Demographics Service (PDS). Moving to something else will require coordination between technology and policy, as it will probably involve non-minor changes in both. This discovery will propose a solution for migrating Breast Screening away from current posting, and will provide intelligence for other pathways that use current_posting. We will discover the size of the work required by doing this discovery, but I'm expecting it to be large enough to be a quarterly goal for at least the 2 teams involved.

This work will need to then consider how to migrate Cervical, Bowel and AAA afterwards.

3\. Diabetic Eye Screening
--------------------------

- **When**: Q3 2025-Q1 2026
- **Teams**: DES, CaaS

DES is an outsourced service, but we provide cohorting to the providers. There is an urgent commercial need to find a new solution. Work is currently underway between the two teams, working together to create a solution. This work will require additional funding to get to production.

4\. Lung Cancer Screening
-------------------------

- **When**: Q1-Q2 2026
- **Teams**: Lung, CaaS

We are a developing a new service for a pre-screening questionnaire for the outsourced lung screening programme. For its private beta it will be extracting the cohort from the supplier, and then providing data back to the supplier. For the next stage of work, it will get the cohort directly from GP systems via CaaS, and then provide the cohort along with questionnaire results to the supplier.

5\. Cervical Screening
----------------------

- **When**: Q3-Q4 2025
- **Teams**: CSMS End User Team, CaaS

CSMS currently extracts its cohort directly from PDS. This is causing many issues for them. We want them to get their cohort from CaaS. This work would involve migrating to PDS for demographics, but not migrating away from current posting as part of this work.

6\. AAA
-------

- **When**: Q2-Q3 2026
- **Teams**: AAA Team, CaaS

By the time we get to AAA, we should hopefully have created all of the solutions required to make this migration quite simple. This work would involve migrating to PDS for demographics, and maybe away from current posting.

7\. Bowel Screening
-------------------

- **When**: Q3-Q4 2026
- **Teams**: Bowel Team 2, CaaS

Bowel currently has seemingly few problems with cohorting, and the team needs to focus on other areas of technical debt. Once that technical debt has been worked on, it will make it easier to do this migration.

Summary
-------

We will not be able to decommission PI until we have completed steps 1, 6 and 7, which means that PI will need to be maintained until an estimated mid-2027.

Impact on Architecture
----------------------

The current [Digital Screening Architecture is viewable here](https://nhsdigital.github.io/digital-screening-architecture/?diagram=digital_screening). Once CaaS has been fully onboarded, [it will look like this](https://nhsdigital.github.io/digital-screening-architecture/pr-preview/pr-4/?diagram=digital_screening).
