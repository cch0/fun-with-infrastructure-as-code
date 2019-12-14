from pulumi_gcp import organizations
import pulumi


def provision(config: dict, parent_folder_id):
    print('parent_folder_id:', parent_folder_id)

    folder_name = config['folder_name']

    # provision folder
    folder = organizations.Folder(folder_name,
                                  display_name=folder_name,
                                  parent=parent_folder_id
                                  )

    pulumi.export('folder_id', folder.id)

    return folder
