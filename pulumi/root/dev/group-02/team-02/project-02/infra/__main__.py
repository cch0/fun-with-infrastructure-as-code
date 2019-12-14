from pulumi import StackReference

from package import api
from package import env, config_util
from package import project
from package import project_iam

# billing account id
billing_account_id = env.get('billing_account')

config = config_util.read('config.yaml')

# retrieve parent stack to obtain parent folder id
parent = StackReference(config['parent_stack_name'])
parent_folder_id = parent.get_output("folder_id")

project_config = config['project']

# provision project
project = project.provision(project_config, parent_folder_id, billing_account_id)

# provision project IAM
project_iam.provision(project_config, project.id)

# provision enabled APIs
api.provision(project_config, project.id)
