from pulumi_gcp import projects


def provision(config: dict, project_id: str):
    # project:
    #   iam_bindings:
    #     'roles/editor':
    #       - 'group:GROUP_EMAIL1'
    #       - 'group:GROUP_EMAIL2'
    #     'roles/compute.viewer':
    #       - 'group:GROUP_EMAIL3'

    if 'iam_bindings' in config:
        iam_bindings = config['iam_bindings']

        for role in iam_bindings.keys():
            members = iam_bindings[role]

            print('configure role:' + role + " to members:" + str(members))

            iam_binding = projects.IAMBinding(role, members=members, project=project_id, role=role)

            print(iam_binding.role)
            print(iam_binding.members)
