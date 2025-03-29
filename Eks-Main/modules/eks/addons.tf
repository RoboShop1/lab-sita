# resource "aws_eks_addon" "addons" {
#
#   depends_on                  = [aws_eks_node_group.main]
#   for_each                    =  var.addons
#   cluster_name                = aws_eks_cluster.example.name
#   addon_name                  = each.key
#   addon_version               = each.value["addon_version"]
#   resolve_conflicts_on_update = "OVERWRITE"
# }