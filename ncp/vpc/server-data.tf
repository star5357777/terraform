data "ncloud_server_image" "server_image" {
        filter {
                name = "product_name"
                values = ["centos-7.3-64"]
        }
}

data "ncloud_server_product" "product" {
        server_image_product_code = data.ncloud_server_image.server_image.id

        filter {
                name = "product_code"
                values = ["SSD"]
                regex = true
        }
        filter {
                name = "cpu_count"
                values = ["2"]
        }
        filter {
                name = "memory_size"
                values = ["8GB"]
        }
        filter {
                name = "product_type"
                values = ["STAND"]
        }
}

