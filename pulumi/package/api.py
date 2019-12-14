from pulumi_gcp import projects


def provision(config: dict, project_id: str):

    services_config = config['services']
    disable_dependent_services = services_config['disable_dependent_services']
    apis = services_config['apis']

    for api in apis:
        projects.Service(api, disable_dependent_services=disable_dependent_services, project=project_id, service=api)