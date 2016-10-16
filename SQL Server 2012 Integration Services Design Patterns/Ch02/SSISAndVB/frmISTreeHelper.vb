' 
' frmISTreeHelper module
'
' I use a Helper Pattern when developing interfaces.
' Each form is named frm_____ and there is a corresponding module named frm_____Helper.vb.
' Each event method calls a subroutine in the Helper module.
'
' This module supports frmISTree.
'

Imports Microsoft.SqlServer.Management.IntegrationServices
Imports Microsoft.SqlServer.Management.Smo

Module frmISTreeHelper

    '  variables
    Public sFullSSISPkgPath As String

    Sub frmISTreeInit()

        ' initialize and load frmISTree

        With frmISTree
            .Text = "Integration Services"
            .txtServer.Text = "localhost"
            .ShowDialog()
        End With

    End Sub

    Sub btnConnectClick()

        ' connect to the server indicated in the txtServer textbox
        ' hook into the SSISDB catalog
        ' build out the SSISDB node by iterating the objects stored therein
        ' load the node and display it

        With frmISTree
            Dim oServer As New Server(.txtServer.Text)
            Dim oIS As New IntegrationServices(oServer)
            Dim cat As Catalog = oIS.Catalogs("SSISDB")
            Dim L1Node As New TreeNode("SSISDB")
            L1Node.ImageIndex = 0
            Dim L2Node As TreeNode
            Dim L3Node As TreeNode
            Dim L4Node As TreeNode

            For Each f As CatalogFolder In cat.Folders
                L2Node = New TreeNode(f.Name)
                L2Node.ImageIndex = 1
                L1Node.Nodes.Add(L2Node)
                '.tvCatalog.Nodes.Add(L2Node)
                For Each pr As ProjectInfo In f.Projects
                    L3Node = New TreeNode(pr.Name)
                    L3Node.ImageIndex = 2
                    L2Node.Nodes.Add(L3Node)
                    '.tvCatalog.Nodes.Add(L3Node)
                    For Each pkg As PackageInfo In pr.Packages
                        L4Node = New TreeNode(pkg.Name)
                        L4Node.ImageIndex = 3
                        L3Node.Nodes.Add(L4Node)
                        '.tvCatalog.Nodes.Add(L4Node)
                    Next
                Next
            Next

            .tvCatalog.Nodes.Add(L1Node)
        End With

    End Sub

    Sub btnSelectClick()

        ' if the image index level indicates a package,
        ' select this node, populate the sFullSSISPkgPath variable,
        ' and close the form

        With frmISTree
            If Not .tvCatalog.SelectedNode Is Nothing Then
                If .tvCatalog.SelectedNode.ImageIndex = 3 Then
                    sFullSSISPkgPath = .txtServer.Text & "." & _
                    .tvCatalog.SelectedNode.FullPath()
                    .Close()
                End If
            End If
        End With

    End Sub

    Sub tvCatalogDoubleClick()

        ' run the Select Click logic

        With frmISTree
            btnSelectClick()
        End With

    End Sub

End Module
