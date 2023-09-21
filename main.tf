provider "aws"{
    region="ap-south-1"
    access_key="AKIAZNJHT2M6O56C5FMS"
    secret_key="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"

}
resource "aws_instance" "terraform"{
    ami="ami-0c3c912253ec8a579"
    instance_type="t2_micro"
    tag={
        name="Lakshmiprasad"
    }
}
