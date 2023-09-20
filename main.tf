provider "aws"{
    region="ap-south-1"
    access_key="AKIAZNJHT2M6IDKJSVDC"
    secret_key="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"

}
resource "aws_instance" "terraform"{
    ami="ami-0c3c912253ec8a579"
    instance_type="t2_micro"
    tag={
        name="Lakshmiprasad"
    }
}
