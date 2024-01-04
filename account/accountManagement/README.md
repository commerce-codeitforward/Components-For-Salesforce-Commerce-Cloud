# Account Management (B2B Commerce)

## Table of Contents
<details open><summary>Click to open/close</summary>

- [Overview](#overview)
- [Deploy](#deploy)
    - [Deploy Using Workbench](#deploy-using-workbench)
    - [Deploy Using sfdx](#deploy-using-sfdx)
- [Update Permissions](#update-permissions)
    - [Allow Profiles to Access the AccountManagement Class](#allow-profiles-to-access-the-accountmanagement-class)
    - [Ensure your Buyer Manager has "Delegated External User Administrator" Permissions](#ensure-your-buyer-manager-has-delegated-external-user-administrator-permissions)
        - [Option 1: Add the Permission to a Permission Set](#option-1-add-the-permission-to-a-permission-set)
        - [Option 2: Add the Permission to a Profile](#option-2-add-the-permission-to-a-profile)
- [Create the Account Management Page](#create-the-account-management-page)
- [Add the Account Management Page to the User Profile Navigation Menu](#add-the-account-management-page-to-the-user-profile-navigation-menu)
- [Confirm the Account Management Page is Working](#confirm-the-account-management-page-is-working)
- [Add New Buyer Members/Users](#add-new-buyer-members--users)
</details>

## Overview
This component:
1. lists Buyer Members/Users and Carts
2. allows a Buyer Manager with **Delegated External User Administrator** permissions to create new contacts and buyer members

## Deploy

### Deploy Using Workbench

1. `cd` to the directory containing this file (e.g.: `cd account/accountManagement`).
2. Create a .zip file of this directory: `zip -r -X <your-zip-file>.zip *`
3. Open [Workbench](https://workbench.developerforce.com/) and go to **migration** -> **Deploy**.
4. Click **Choose File** and navigate to the .zip file you created (`<your-zip-file>.zip`).
5. Select **Single Package**
6. Click **Next**
7. Click **Deploy**

### Deploy Using sfdx
Run `sf force mdapi deploy -d <path-to-this-directory> -u <org-username> -w -1`

## Update Permissions

### Allow Profiles to Access the AccountManagement Class
1. Navigate to **Setup** -> **Apex Classes**
2. Click the label for the **AccountManagement** class
3. Click the **Security** button
4. Add all allowed profiles to the **Enabled Profiles** list (e.g.: your `Buyer Profile` or `Customer Community Plus`, etc.)
5. Click **Save**

### Ensure your Buyer Manager has "Delegated External User Administrator" Permissions

#### Option 1: Add the Permission to a Permission Set
> Note: There is an example permission set in this repository called [External User Admin](./permissionsets/External_User_Admin.permissionset-meta.xml). You can use this permission set or create your own.
> 
1. Navigate to **Setup** -> **Users** -> **Permission Sets**
2. Click **New**
3. Enter a Label and Name for the permission set (e.g.: `External User Admin`)
4. Select **Customer Community Plus** for the license
5. Click **Save**
6. Click **App Permissions**
7. Click **Edit**
8. Under **Partner Relationship Management**, check the **Delegated External User Administrator** checkbox
9. Click **Save**
10. Click **Manage Assignments**
11. Click **Add Assignments**
12. Select the applicable Buyer Manager users

Additional Resources:
- [Delegate Site Administration to an External User](https://help.salesforce.com/s/articleView?id=sf.networks_DPUA.htm&type=5)

#### Option 2: Add the Permission to a Profile
1. Navigate to **Setup** -> **Users** -> **Profiles**
2. Click the label for the applicable profile (e.g.: `Buyer Manager Profile`)
3. Click **Edit**
4. Under **Administrative Permissions**, check the **Delegated External User Administrator** checkbox
5. Click **Save**

## Create the Account Management Page
1. Navigate to **Setup** -> **Digital Experiences** -> **All Sites** -> Click the **Builder** link for your site
2. In the top left hand corner, click the gear icon and then the **+ New Page** button
   - ![New Page](./docs/images/experience-new-page.png)
3. Click the **Standard Page** tile
4. Enter a **Name** (`Account Management`), **URL** (`account-management`), and API Name (e.g.: `Account_Management`) for the page.
5. Click **Create**
   - ![Account Management Page](./docs/images/experience-acct-mgnt-page.png)
6. Click the lightning bolt icon in the top left corner of the page
7. Drag the **Account Management** component from the **Custom Components** section to the page
   - ![Account Management Component](./docs/images/experience-acct-mgnt-component.png)
8. Configure the **Settings** tab on the **Account Management** component
9. Click **Publish** in the top right corner of the page
   - ![Account Management Component Settings](./docs/images/experience-acct-mgnt-component-settings.png)

## Add the Account Management Page to the User Profile Navigation Menu
1. Navigate to **Setup** -> **Digital Experiences** -> **All Sites** -> Click the **Builder** link for your site
2. On the right hand side, click the **Profile Menu** component
   - ![Profile Menu Component](./docs/images/experience-profile-menu-component.png)
3. On the Settings tab, expand the **Authenticated User Menu** and click the **Edit Default User Profile Menu** button
   - ![Edit Profile Menu](./docs/images/experience-edit-default-profile-menu.png)
4. Click the **Add Menu Item** button
5. Configure the following:
   - Type: `Site Page`
   - Name: `Account Management`
   - Page: `Account Management`
6. Drag the **Account Management** menu item to the desired location in the menu
7. Click **Save Menu** 
   - ![Edit Profile Menu](./docs/images/experience-acct-mgnt-menu.png)
8. Click **Publish** in the top right corner of the page

## Confirm the Account Management Page is Working
Navigate to the Account Management page in your community and confirm:
1. you see a list of users and carts for your `Buyer Manager` users
   - ![Buyer Manager Members](./docs/images/buyer-mngr-members.png)
   - ![Buyer Manager Carts](./docs/images/buyer-mngr-carts.png)
2. regular buyers see only their own user and cart
   - ![Buyer Members](./docs/images/buyer-members.png)
   - ![Buyer Carts](./docs/images/buyer-carts.png)

## Add New Buyer Members / Users
The **addCommunityUser** component can be used to add new contacts and community members/users. This component is available on the **Account Management** page for users with **Delegated External User Administrator** permissions. You can select an existing contact tied to the account or create a new contact. A new community user will be created and tied to the account and contact.
![Add Buyer Member](./docs/images/add-buyer-member.png)

The list of available profiles on the component are pulled from the selected profiles on your community:
1. Navigate to **Setup** -> **Digital Experiences** -> **All Sites** -> Click the **Workspaces** link for your site
2. Click the **Administration** tile
3. Click **Members** in the left hand navigation
4. The **Selected Profiles**, excluding the System Administrator profile, are the profiles that will be available on the **addCommunityUser** component
![Selected Profiles](./docs/images/experience-selected-profiles.png)

### Prerequisites
The following prerequisites must be met before a Buyer Manager can create a new buyer contact and user:
1. The Buyer Manager must have **Delegated External User Administrator** permissions. See [Ensure your Buyer Manager has "Delegated External User Administrator" Permissions](#ensure-your-buyer-manager-has-delegated-external-user-administrator-permissions)
2. The Buyer Manager must have a **Buyer Manager Profile** (or profile with access to the **AccountManagement** class). See [Allow Profiles to Access the AccountManagement Class](#allow-profiles-to-access-the-accountmanagement-class)
3. The Buyer Manager must have the **Buyer Manager** permission set
4. Assign the list of allowable user profiles to the Buyer Manager's profile:
   1. Navigate to **Setup** -> **Users** -> **Profiles**
   2. Click the label for the applicable Buyer Manager profile (e.g.: `Buyer Manager Profile`)
   3. Search for **Delegated External User Profiles** (near bottom of page)
      - ![Delegated External User Profiles](./docs/images/buyer-mngr-profile-add-allowed-profiles.png)
   4. Click **Edit**
   5. Check all the applicable profiles (e.g.: `Buyer Profile`, `Customer Community Plus`, etc.)
   6. Click **Save**
      - ![Delegated External User Profiles](./docs/images/buyer-mngr-profile-select-allowed-profiles.png)
5. If you need additional permission sets added to your buyer member users, this can be done by specifying a comma-seperated list of **Permission Set API Names** on the component
    - ![Permission Set API Names on Component](./docs/images/permission-set-api-name-component.png)
    - ![Permission Set API Name](./docs/images/permission-set-api-name.png)
