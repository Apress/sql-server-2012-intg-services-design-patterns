' 
' frmMainHelper module
'
' I use a Helper Pattern when developing interfaces.
' Each form is named frm_____ and there is a corresponding module named frm_____Helper.vb.
' Each event method calls a subroutine in the Helper module.
'
' This module supports frmMain.
'
Imports System
Imports System.Windows
Imports System.Windows.Forms
Imports Microsoft.SqlServer.Dts.Runtime.Wrapper
Imports Microsoft.SqlServer.Management.IntegrationServices
Imports Microsoft.SqlServer.Management.Smo

Module frmMainHelper

    Public Sub InitFrmMain()

        ' initialize and load frmISTree

        ' define the version
        Dim sVer As String = System.Windows.Forms.Application.ProductName & "  v" & _
System.Windows.Forms.Application.ProductVersion

        ' display the version and startup status
        With frmMain
            .Text = sVer
            .txtStatus.Text = sVer & ControlChars.CrLf & "Ready"
        End With

    End Sub

    Public Sub btnStartFileClick()

        ' configure an SSIS application and execute the selected SSIS package file

        With frmMain
            .Cursor = Cursors.WaitCursor
            .txtStatus.Text = "Executing " & .txtSSISPkgPath.Text
            .Refresh()
            Dim ssisApp As New Microsoft.SqlServer.Dts.Runtime.Wrapper.Application
            Dim ssisPkg As Package = ssisApp.LoadPackage(.txtSSISPkgPath.Text, _
AcceptRejectRule.None, Nothing)
            ssisPkg.Execute()
            .Cursor = Cursors.Default
            .txtStatus.Text = .txtSSISPkgPath.Text & " executed."
        End With

    End Sub

    Public Sub btnOpenSSISPkgClick()

        ' allow the user to navigate to an SSIS package file

        With frmMain
            .OpenFileDialog1.DefaultExt = "dtsx"
            .OpenFileDialog1.ShowDialog()
            .txtSSISPkgPath.Text = .OpenFileDialog1.FileName
            .txtStatus.Text = .txtSSISPkgPath.Text & " package path loaded."
        End With

    End Sub

    Sub btnOpenSSISPkgInCatalogClick()

        ' allow the user to navigate to an SSIS package stored in a catalog

        frmISTreeInit()

        Dim sTmp As String = sFullSSISPkgPath
        Dim sServerName As String = Strings.Left(sTmp, Strings.InStr(sTmp, ".") - 1)
        Dim iStart As Integer = Strings.InStr(sTmp, ".") + 1
        Dim iEnd As Integer = Strings.InStr(sTmp, "\")
        Dim iLen As Integer
        Dim sCatalogName As String
        Dim sFolderName As String
        Dim sProjectName As String
        Dim sPackageName As String

        If iEnd > iStart Then
            iLen = iEnd - iStart
            sCatalogName = Strings.Mid(sTmp, iStart, iLen)
            sTmp = Strings.Right(sTmp, Strings.Len(sTmp) - iEnd)

            iStart = 1
            iEnd = Strings.InStr(sTmp, "\")
            If iEnd > iStart Then
                iLen = iEnd - iStart
                sFolderName = Strings.Mid(sTmp, iStart, iLen)
                sTmp = Strings.Right(sTmp, Strings.Len(sTmp) - iEnd)

                iStart = 1
                iEnd = Strings.InStr(sTmp, "\")
                If iEnd > iStart Then
                    iLen = iEnd - iStart
                    sProjectName = Strings.Mid(sTmp, iStart, iLen)
                    sTmp = Strings.Right(sTmp, Strings.Len(sTmp) - iEnd)
                    sPackageName = sTmp
                End If
            End If
        End If


        With frmMain
            .txtSSISCatalogServer.Text = sServerName
            .txtCatalog.Text = sCatalogName
            .txtFolder.Text = sFolderName
            .txtCatalogProject.Text = sProjectName
            .txtCatalogPackage.Text = sPackageName
            .txtStatus.Text = sFullSSISPkgPath & " metadata loaded and parsed."
        End With

    End Sub

    Sub btnStartCatalogClick()

        ' configure an SSIS application and execute the selected SSIS package from the 
        ' catalog

        With frmMain
            .Cursor = Cursors.WaitCursor
            .txtStatus.Text = "Loading " & sFullSSISPkgPath
            .Refresh()
            Dim oServer As New Server(.txtSSISCatalogServer.Text)
            Dim oIS As New IntegrationServices(oServer)
            Dim cat As Catalog = oIS.Catalogs(.txtCatalog.Text)
            Dim fldr As CatalogFolder = cat.Folders(.txtFolder.Text)
            Dim prj As ProjectInfo = fldr.Projects(.txtCatalogProject.Text)
            Dim pkg As PackageInfo = prj.Packages(.txtCatalogPackage.Text)
            .txtStatus.Text = sFullSSISPkgPath & " loaded. Starting validation..."
            .Refresh()
            pkg.Validate(False, PackageInfo.ReferenceUsage.UseAllReferences, Nothing)
            .txtStatus.Text = sFullSSISPkgPath & " validated. Starting execution..."
            .Refresh()
            pkg.Execute(False, Nothing)
            .txtStatus.Text = sFullSSISPkgPath & " execution started."
            .Cursor = Cursors.Default
        End With

    End Sub

End Module
