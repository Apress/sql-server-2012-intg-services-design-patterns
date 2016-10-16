' 
' frmISTree code
'
' I use a Helper Pattern when developing interfaces.
' Each form is named frm_____ and there is a corresponding module named frm_____Helper.vb.
' Each event method calls a subroutine in the Helper module.
' 
Public Class frmISTree

    Private Sub btnConnect_Click(ByVal sender As System.Object, _
                                 ByVal e As System.EventArgs) Handles btnConnect.Click
        btnConnectClick()
    End Sub

    Private Sub btnSelect_Click(ByVal sender As System.Object, _
                                ByVal e As System.EventArgs) Handles btnSelect.Click
        btnSelectClick()
    End Sub

    Private Sub tvCatalog_AfterSelect(ByVal sender As System.Object, _
                                      ByVal e As System.Windows.Forms.TreeViewEventArgs) _
Handles tvCatalog.AfterSelect

    End Sub

    Private Sub tvCatalog_DoubleClick(ByVal sender As Object, _
                                      ByVal e As System.EventArgs) _
Handles tvCatalog.DoubleClick
        tvCatalogDoubleClick()
    End Sub
End Class
