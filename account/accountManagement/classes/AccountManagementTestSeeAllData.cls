@IsTest(SeeAllData=true)
public class AccountManagementTestSeeAllData {
    @IsTest(SeeAllData=true)
    static void testGetSelectedProfilesForCommunity() {
        // Get a real community Id from your org
        Network community = [SELECT Id FROM Network LIMIT 1];
        String communityId = community.Id;

        List<Profile> result = AccountManagement.getSelectedProfilesForCommunity(communityId);
        System.assertNotEquals(null, result, 'Expected result to be not null');
        System.assertNotEquals(0, result.size(), 'Expected result to be not empty');
    }
}