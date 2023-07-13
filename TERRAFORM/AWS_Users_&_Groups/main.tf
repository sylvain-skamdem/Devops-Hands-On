# Defining IAM GROUP
resource "aws_iam_group" "Sk_Devops_Group" {
  name = "DevOpsEngineers"
}

# Defining IAM USERS
resource "aws_iam_user" "Eng-user" {
  for_each = toset(var.users)
  name     = each.key
  path     = "/users/"
}


# Adding IAM USERS TO THE GROUP
resource "aws_iam_user_group_membership" "Sk_Devops_Mbshp" {
  for_each = aws_iam_user.Eng-user
  groups   = [aws_iam_group.Sk_Devops_Group.name]
  user     = aws_iam_user.Eng-user[each.key].name
}
