public class AccountManagementJob implements System.Queueable {
    private List<PermissionSetAssignment> permissionSetAssignments;

    public AccountManagementJob(List<PermissionSetAssignment> permissionSetAssignments) {
        this.permissionSetAssignments = permissionSetAssignments;
    }

    public void execute(System.QueueableContext context) {
        try {
            List<Database.SaveResult> saveResults = Database.insert(permissionSetAssignments, false);
            for (Database.SaveResult saveResult : saveResults) {
                if (!saveResult.isSuccess()) {
                    for (Database.Error error : saveResult.getErrors()) {
                        System.debug('AccountManagementJob: Failed to assign permission set: ' + error.getMessage());
                    }
                }
            }
        } catch (Exception e) {
            System.debug('AccountManagementJob: Exception occurred: ' + e.getMessage());
        }
    }
}