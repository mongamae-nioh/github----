# EC2 Key Pairs
resource "aws_key_pair" "pubkey" {
  key_name   = "pubkey"
  public_key = file("./pubkey.pub")
}
