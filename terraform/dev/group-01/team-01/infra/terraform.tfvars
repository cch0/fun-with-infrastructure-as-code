folder_name   = "team-01"
folder_prefix = "dev"

# assign roles/owner permission at this level so that
# any future project will inherit it once created
iam-role-memberships = {
    "roles/owner" : [
        "group:GROUP_EMAIL",
    ]
}