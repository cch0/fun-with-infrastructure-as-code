from pulumi_gcp import storage, pulumi


def provision(config: dict, project_id: str):
    if 'buckets' in config:
        bucket_configs = config['buckets']

        for bucket_name in bucket_configs.keys():
            bucket_config = bucket_configs[bucket_name]

            bucket = storage.Bucket(bucket_name,
                                    name=bucket_name,
                                    project=project_id,
                                    location=bucket_config['location'],
                                    storage_class=bucket_config['storage_class'],
                                    versioning=bucket_config['versioning'])

            pulumi.export('bucket_id:' + bucket_name, bucket.id)

            if 'acl' in bucket_config:
                acl_config = bucket_config['acl']
                resource_name = bucket_name + '-acl'

                if 'predefined_acl' in acl_config:
                    predefined_acl_value = acl_config['predefined_acl']
                else:
                    predefined_acl_value = None

                if 'role_entities' in acl_config:
                    role_entities_value = acl_config['role_entities']
                else:
                    role_entities_value = None

                acl = storage.BucketACL(resource_name,
                                        # using bucket.name instead of bucket_name to "indicate" this resource depends
                                        # on bucket to be created first. otherwise, ACL may be created in parallel while
                                        # bucket is being created and operation will fail
                                        bucket=bucket.name,
                                        predefined_acl=predefined_acl_value,
                                        role_entities=role_entities_value)

                pulumi.export('bucket_acl:' + resource_name, acl.id)
