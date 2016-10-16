' 
' frmMain code
'
' I use a Helper Pattern when developing interfaces.
' Each form is named frm_____ and there is a corresponding module named frm_____Helper.vb.
' Each event method calls a subroutine in the Helper module.
' 

Public Class frmMain

    Private Sub frmMain_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        InitFrmMain()
    End Sub

    Private Sub btnStartFile_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnStartFile.Click
        btnStartFileClick()
    End Sub

    Private Sub btnOpenSSISPkg_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnOpenSSISPkg.Click
        btnOpenSSISPkgClick()
    End Sub

    Private Sub btnStartCatalog_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnStartCatalog.Click
        btnStartCatalogClick()
    End Sub

    Private Sub btnOpenSSISPkgInCatalog_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnOpenSSISPkgInCatalog.Click
        btnOpenSSISPkgInCatalogClick()
    End Sub
End Class
