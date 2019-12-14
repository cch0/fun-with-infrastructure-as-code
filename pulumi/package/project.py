import os

import pulumi
from pulumi_gcp import organizations
from pulumi_gcp import projects


def provision(config: dict, parent_folder_id, billing_account_id: str):
    project_name = config['project_name']
    auto_create_network = config['auto_create_network']

    project_id = None

    # find out if existing active project exists for the project_name. if yes, find out project_id
    print('search project with project_name:' + project_name)
    get_project_result = projects.get_project(filter='name:' + project_name)

    if get_project_result:
        for item in get_project_result.projects:
            result = organizations.get_project(project_id=item['projectId'])

            if result.number:
                print('\tactive project exists for the same project_name, project_id:', item['projectId'],
                      ', project_number:', result.number)
                project_id = item['projectId']
                break

    if project_id is None:
        print('project_id is unknown, creating one')
        project_id_suffix = os.urandom(4).hex()

        # construct project id from project name and project id suffix
        project_id = project_name + '-' + project_id_suffix
        print('constructed project_id:', project_id)

    # provision project
    project = organizations.Project(
        project_name,
        name=project_name,
        project_id=project_id,
        auto_create_network=auto_create_network,
        billing_account=billing_account_id,
        folder_id=parent_folder_id
    )

    pulumi.export('project_id', project.id)

    return project
