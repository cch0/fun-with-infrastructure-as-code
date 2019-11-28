
bucket_config = {
    "bucket-01": {
        storage_class      : "STANDARD",
        versioning_enabled : true,
        acl                : {
            predefined_acl: "",
            role_entity: [
                "WRITER:GROUP_EMAIL",
            ],
        }
    },
    "bucket-02": {
        storage_class      : "NEARLINE",
        versioning_enabled : false,
        acl                : {
            predefined_acl = "projectPrivate",
            role_entity: []
        }
    },
}