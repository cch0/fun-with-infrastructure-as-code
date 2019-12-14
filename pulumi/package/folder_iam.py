from pulumi_gcp import folder


def provision(config: dict, folder_id: str):
    # folder:
    #   iam_bindings:
    #     'roles/resourcemanager.folderMover':
    #       - 'group:GROUP_EMAIL1'
    #       - 'group:GROUP_EMAIL2'
    #     'roles/resourcemanager.folderViewer':
    #       - 'group:GROUP_EMAIL3'
    if 'iam_bindings' in config:
        iam_bindings = config['iam_bindings']

        for role in iam_bindings.keys():
            members = iam_bindings[role]

            print('configure role:' + role + " to members:" + str(members))

            iam_binding = folder.IAMBinding(role,
                                            members=members,
                                            folder=folder_id,
                                            role=role)

            print(iam_binding.role)
            print(iam_binding.members)

