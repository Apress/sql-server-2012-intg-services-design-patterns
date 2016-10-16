<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class frmMain
    Inherits System.Windows.Forms.Form

    'Form overrides dispose to clean up the component list.
    <System.Diagnostics.DebuggerNonUserCode()> _
    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        Try
            If disposing AndAlso components IsNot Nothing Then
                components.Dispose()
            End If
        Finally
            MyBase.Dispose(disposing)
        End Try
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> _
    Private Sub InitializeComponent()
        Me.gbFileSystem = New System.Windows.Forms.GroupBox()
        Me.btnStartFile = New System.Windows.Forms.Button()
        Me.btnOpenSSISPkg = New System.Windows.Forms.Button()
        Me.txtSSISPkgPath = New System.Windows.Forms.TextBox()
        Me.Label1 = New System.Windows.Forms.Label()
        Me.GroupBox1 = New System.Windows.Forms.GroupBox()
        Me.btnOpenSSISPkgInCatalog = New System.Windows.Forms.Button()
        Me.btnStartCatalog = New System.Windows.Forms.Button()
        Me.txtCatalogPackage = New System.Windows.Forms.TextBox()
        Me.Label6 = New System.Windows.Forms.Label()
        Me.txtCatalogProject = New System.Windows.Forms.TextBox()
        Me.Label5 = New System.Windows.Forms.Label()
        Me.txtFolder = New System.Windows.Forms.TextBox()
        Me.Label4 = New System.Windows.Forms.Label()
        Me.txtCatalog = New System.Windows.Forms.TextBox()
        Me.Label3 = New System.Windows.Forms.Label()
        Me.txtSSISCatalogServer = New System.Windows.Forms.TextBox()
        Me.Label2 = New System.Windows.Forms.Label()
        Me.txtStatus = New System.Windows.Forms.TextBox()
        Me.OpenFileDialog1 = New System.Windows.Forms.OpenFileDialog()
        Me.gbFileSystem.SuspendLayout()
        Me.GroupBox1.SuspendLayout()
        Me.SuspendLayout()
        '
        'gbFileSystem
        '
        Me.gbFileSystem.Controls.Add(Me.btnStartFile)
        Me.gbFileSystem.Controls.Add(Me.btnOpenSSISPkg)
        Me.gbFileSystem.Controls.Add(Me.txtSSISPkgPath)
        Me.gbFileSystem.Controls.Add(Me.Label1)
        Me.gbFileSystem.Location = New System.Drawing.Point(13, 13)
        Me.gbFileSystem.Name = "gbFileSystem"
        Me.gbFileSystem.Size = New System.Drawing.Size(517, 76)
        Me.gbFileSystem.TabIndex = 0
        Me.gbFileSystem.TabStop = False
        Me.gbFileSystem.Text = "SSIS Package in the File System"
        '
        'btnStartFile
        '
        Me.btnStartFile.Location = New System.Drawing.Point(444, 43)
        Me.btnStartFile.Name = "btnStartFile"
        Me.btnStartFile.Size = New System.Drawing.Size(67, 23)
        Me.btnStartFile.TabIndex = 3
        Me.btnStartFile.Text = "Start"
        Me.btnStartFile.UseVisualStyleBackColor = True
        '
        'btnOpenSSISPkg
        '
        Me.btnOpenSSISPkg.Location = New System.Drawing.Point(473, 14)
        Me.btnOpenSSISPkg.Name = "btnOpenSSISPkg"
        Me.btnOpenSSISPkg.Size = New System.Drawing.Size(38, 23)
        Me.btnOpenSSISPkg.TabIndex = 2
        Me.btnOpenSSISPkg.Text = "..."
        Me.btnOpenSSISPkg.UseVisualStyleBackColor = True
        '
        'txtSSISPkgPath
        '
        Me.txtSSISPkgPath.Location = New System.Drawing.Point(82, 17)
        Me.txtSSISPkgPath.Name = "txtSSISPkgPath"
        Me.txtSSISPkgPath.Size = New System.Drawing.Size(380, 20)
        Me.txtSSISPkgPath.TabIndex = 1
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(7, 20)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(78, 13)
        Me.Label1.TabIndex = 0
        Me.Label1.Text = "Package Path:"
        Me.Label1.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'GroupBox1
        '
        Me.GroupBox1.Controls.Add(Me.btnOpenSSISPkgInCatalog)
        Me.GroupBox1.Controls.Add(Me.btnStartCatalog)
        Me.GroupBox1.Controls.Add(Me.txtCatalogPackage)
        Me.GroupBox1.Controls.Add(Me.Label6)
        Me.GroupBox1.Controls.Add(Me.txtCatalogProject)
        Me.GroupBox1.Controls.Add(Me.Label5)
        Me.GroupBox1.Controls.Add(Me.txtFolder)
        Me.GroupBox1.Controls.Add(Me.Label4)
        Me.GroupBox1.Controls.Add(Me.txtCatalog)
        Me.GroupBox1.Controls.Add(Me.Label3)
        Me.GroupBox1.Controls.Add(Me.txtSSISCatalogServer)
        Me.GroupBox1.Controls.Add(Me.Label2)
        Me.GroupBox1.Location = New System.Drawing.Point(13, 95)
        Me.GroupBox1.Name = "GroupBox1"
        Me.GroupBox1.Size = New System.Drawing.Size(517, 102)
        Me.GroupBox1.TabIndex = 1
        Me.GroupBox1.TabStop = False
        Me.GroupBox1.Text = "SSIS Package in the Catalog"
        '
        'btnOpenSSISPkgInCatalog
        '
        Me.btnOpenSSISPkgInCatalog.Location = New System.Drawing.Point(473, 15)
        Me.btnOpenSSISPkgInCatalog.Name = "btnOpenSSISPkgInCatalog"
        Me.btnOpenSSISPkgInCatalog.Size = New System.Drawing.Size(38, 23)
        Me.btnOpenSSISPkgInCatalog.TabIndex = 11
        Me.btnOpenSSISPkgInCatalog.Text = "..."
        Me.btnOpenSSISPkgInCatalog.UseVisualStyleBackColor = True
        '
        'btnStartCatalog
        '
        Me.btnStartCatalog.Location = New System.Drawing.Point(444, 73)
        Me.btnStartCatalog.Name = "btnStartCatalog"
        Me.btnStartCatalog.Size = New System.Drawing.Size(67, 23)
        Me.btnStartCatalog.TabIndex = 10
        Me.btnStartCatalog.Text = "Start"
        Me.btnStartCatalog.UseVisualStyleBackColor = True
        '
        'txtCatalogPackage
        '
        Me.txtCatalogPackage.Location = New System.Drawing.Point(295, 43)
        Me.txtCatalogPackage.Name = "txtCatalogPackage"
        Me.txtCatalogPackage.Size = New System.Drawing.Size(167, 20)
        Me.txtCatalogPackage.TabIndex = 9
        '
        'Label6
        '
        Me.Label6.AutoSize = True
        Me.Label6.Location = New System.Drawing.Point(232, 46)
        Me.Label6.Name = "Label6"
        Me.Label6.Size = New System.Drawing.Size(53, 13)
        Me.Label6.TabIndex = 8
        Me.Label6.Text = "Package:"
        Me.Label6.TextAlign = System.Drawing.ContentAlignment.TopRight
        '
        'txtCatalogProject
        '
        Me.txtCatalogProject.Location = New System.Drawing.Point(54, 43)
        Me.txtCatalogProject.Name = "txtCatalogProject"
        Me.txtCatalogProject.Size = New System.Drawing.Size(151, 20)
        Me.txtCatalogProject.TabIndex = 7
        '
        'Label5
        '
        Me.Label5.AutoSize = True
        Me.Label5.Location = New System.Drawing.Point(7, 46)
        Me.Label5.Name = "Label5"
        Me.Label5.Size = New System.Drawing.Size(43, 13)
        Me.Label5.TabIndex = 6
        Me.Label5.Text = "Project:"
        Me.Label5.TextAlign = System.Drawing.ContentAlignment.TopRight
        '
        'txtFolder
        '
        Me.txtFolder.Location = New System.Drawing.Point(349, 17)
        Me.txtFolder.Name = "txtFolder"
        Me.txtFolder.Size = New System.Drawing.Size(113, 20)
        Me.txtFolder.TabIndex = 5
        '
        'Label4
        '
        Me.Label4.AutoSize = True
        Me.Label4.Location = New System.Drawing.Point(304, 20)
        Me.Label4.Name = "Label4"
        Me.Label4.Size = New System.Drawing.Size(39, 13)
        Me.Label4.TabIndex = 4
        Me.Label4.Text = "Folder:"
        Me.Label4.TextAlign = System.Drawing.ContentAlignment.TopRight
        '
        'txtCatalog
        '
        Me.txtCatalog.Location = New System.Drawing.Point(202, 17)
        Me.txtCatalog.Name = "txtCatalog"
        Me.txtCatalog.Size = New System.Drawing.Size(96, 20)
        Me.txtCatalog.TabIndex = 3
        '
        'Label3
        '
        Me.Label3.AutoSize = True
        Me.Label3.Location = New System.Drawing.Point(150, 20)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(46, 13)
        Me.Label3.TabIndex = 2
        Me.Label3.Text = "Catalog:"
        Me.Label3.TextAlign = System.Drawing.ContentAlignment.TopRight
        '
        'txtSSISCatalogServer
        '
        Me.txtSSISCatalogServer.Location = New System.Drawing.Point(54, 17)
        Me.txtSSISCatalogServer.Name = "txtSSISCatalogServer"
        Me.txtSSISCatalogServer.Size = New System.Drawing.Size(90, 20)
        Me.txtSSISCatalogServer.TabIndex = 1
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Location = New System.Drawing.Point(7, 20)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(41, 13)
        Me.Label2.TabIndex = 0
        Me.Label2.Text = "Server:"
        Me.Label2.TextAlign = System.Drawing.ContentAlignment.TopRight
        '
        'txtStatus
        '
        Me.txtStatus.BackColor = System.Drawing.SystemColors.ButtonFace
        Me.txtStatus.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtStatus.Location = New System.Drawing.Point(13, 203)
        Me.txtStatus.Multiline = True
        Me.txtStatus.Name = "txtStatus"
        Me.txtStatus.Size = New System.Drawing.Size(511, 47)
        Me.txtStatus.TabIndex = 2
        '
        'OpenFileDialog1
        '
        Me.OpenFileDialog1.FileName = "OpenFileDialog1"
        '
        'frmMain
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(542, 262)
        Me.Controls.Add(Me.txtStatus)
        Me.Controls.Add(Me.GroupBox1)
        Me.Controls.Add(Me.gbFileSystem)
        Me.Name = "frmMain"
        Me.Text = "frmMain"
        Me.gbFileSystem.ResumeLayout(False)
        Me.gbFileSystem.PerformLayout()
        Me.GroupBox1.ResumeLayout(False)
        Me.GroupBox1.PerformLayout()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents gbFileSystem As System.Windows.Forms.GroupBox
    Friend WithEvents btnOpenSSISPkg As System.Windows.Forms.Button
    Friend WithEvents txtSSISPkgPath As System.Windows.Forms.TextBox
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents btnStartFile As System.Windows.Forms.Button
    Friend WithEvents GroupBox1 As System.Windows.Forms.GroupBox
    Friend WithEvents txtSSISCatalogServer As System.Windows.Forms.TextBox
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents txtCatalogPackage As System.Windows.Forms.TextBox
    Friend WithEvents Label6 As System.Windows.Forms.Label
    Friend WithEvents txtCatalogProject As System.Windows.Forms.TextBox
    Friend WithEvents Label5 As System.Windows.Forms.Label
    Friend WithEvents txtFolder As System.Windows.Forms.TextBox
    Friend WithEvents Label4 As System.Windows.Forms.Label
    Friend WithEvents txtCatalog As System.Windows.Forms.TextBox
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents btnOpenSSISPkgInCatalog As System.Windows.Forms.Button
    Friend WithEvents btnStartCatalog As System.Windows.Forms.Button
    Friend WithEvents txtStatus As System.Windows.Forms.TextBox
    Friend WithEvents OpenFileDialog1 As System.Windows.Forms.OpenFileDialog

End Class
