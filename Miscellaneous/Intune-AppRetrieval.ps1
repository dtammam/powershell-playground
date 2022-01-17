```py
# Retrieve all apps from the tenant
$apps = Get-IntuneApplication
Write-Host "Retrieved $($apps.count) apps" -ForegroundColor Green
 
# Create a new array object
$Output=New-Object System.Collections.ArrayList
 
ForEach($App in $Apps){
    Write-Host "`nGetting assignments for app: $($app.displayname)" -ForegroundColor Yellow
    $AppID = $app.id
 
    $graphApiVersion = "Beta"
    $Resource = "deviceAppManagement/mobileApps/$AppID/?`$expand=categories,assignments"
    $uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)"
 
    $AppQuery = (invoke-RestMethod -Uri $uri –Headers $authToken –Method Get)
 
    If(($AppQuery.assignments -eq $null) -or ($AppQuery.assignments -eq "") -or ($AppQuery.assignments.count -lt 1)){
 
            Write-Host "No assignments for this app" -ForegroundColor Yellow
 
    } else {
 
        #Write-Host "Platform odata: $($AppQuery.'@odata.type')"
 
                # The many diff types of app in Intune, we switch the variable to the correct platform
 
        $Platform = switch -Wildcard ( $AppQuery.'@odata.type' )
        {
            *androidForWorkApp* { 'Android for Work' }
            *microsoftStoreForBusiness* { 'Microsoft Store' }
            *iosVppApp* { 'Apple VPP' }
            *windowsPhoneXAP* { 'Windows Phone XAP'}
            *webApp* { 'Web Link'}
            default { 'Unknown' }
        }
 
        ForEach($assignment in $AppQuery.assignments){
            # Available or Required
            write-host "Assignment intent: $($assignment.intent)"
 
            If ($($assignment.target.'@odata.type') -like "*allLicensedUsersAssignmentTarget"){
                Write-Host "Published to All Users"
                $GroupName = "All Users"
            } else {
                # Lookup the AAD Group displayname
                write-host "Group ID: $($assignment.target.GroupID)"
                $GroupName = (Get-AzureADgroup -ObjectId $assignment.target.GroupID).DisplayName
            }
 
            # Add all the properties into a new object in the array
            Write-Host "Group Name: $GroupName"
            $Output.Add( (New-Object -TypeName PSObject -Property @{"Name"="$($app.displayname)";"Group" = "$GroupName";"Assignment" = "$($assignment.intent)";"Platform" = "$Platform"} ) )
 
        }
 
    }
 
}
 
# Format the column order by modifying the table output
$output | select Name,Group,Assignment,Platform****```