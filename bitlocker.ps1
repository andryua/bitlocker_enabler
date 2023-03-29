Start-Transcript $env:SYSTEMROOT\TEMP\bitlocaker_enabler.log
$btlkDir = Split-Path -parent $MyInvocation.MyCommand.Definition
$efi = $true
$tpm = $true
$btl_c = $false
$decr_c = $false
$uprofiles = $false
if ($env:FIRMWARE_TYPE -ne "UEFI") {
 $efi = $false
}
if (!((Get-Tpm).TpmEnabled)) {
    $tpm = $false
}
if ((Get-BitLockerVolume).MountPoint.Contains("C:")) {
    $btl_c = $true
    if ((Get-BitLockerVolume).VolumeStatus -eq "FullyDecrypted") {
        $decr_c = $true
    }
    $udir = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\windows nt\CurrentVersion\ProfileList").profilesdirectory
    if (($udir -eq "C:\Users") -or ($udir -eq "%systemdrive%\Users")) {
        $uprofiles = $true
    }
}

#$tpm = $false

$fl1 = "$btlkDir\$efi.png"
$fl2 = "$btlkDir\$tpm.png"
$fl3 = "$btlkDir\$decr_c.png"
$fl4 = "$btlkDir\copy.png"

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$Form = New-Object system.Windows.Forms.Form
$Form.ClientSize = '450,180'
$Form.text = "Bitlocker"
$Form.TopMost = $false
if (Test-Path "icon.ico") {
    $Form.Icon = "icon.ico"
}
$Form.MaximizeBox = $False
$Form.MinimizeBox = $False
$Form.FormBorderStyle = 'Fixed3D'

$Label1 = New-Object system.Windows.Forms.Label
$Label1.text = "BitLocker compatibles check"
$Label1.AutoSize = $true
$Label1.width = 25
$Label1.height = 10
$Label1.location = New-Object System.Drawing.Point(86,9)
$Label1.Font = 'Microsoft Sans Serif,14'

$Label2 = New-Object system.Windows.Forms.Label
$Label2.text = "UEFI"
$Label2.AutoSize = $true
$Label2.width = 25
$Label2.height = 10
$Label2.location = New-Object System.Drawing.Point(29,42)
$Label2.Font = 'Microsoft Sans Serif,10'

$Label3 = New-Object system.Windows.Forms.Label
$Label3.text = "C: can encrypt"
$Label3.AutoSize = $true
$Label3.width = 25
$Label3.height = 10
$Label3.location = New-Object System.Drawing.Point(159,42)
$Label3.Font = 'Microsoft Sans Serif,10'

$Label4 = New-Object system.Windows.Forms.Label
$Label4.text = "TPM"
$Label4.AutoSize = $true
$Label4.width = 25
$Label4.height = 10
$Label4.location = New-Object System.Drawing.Point(337,42)
$Label4.Font = 'Microsoft Sans Serif,10'

$Label5 = New-Object system.Windows.Forms.Label
$Label5.text = "Enter or generate password"
$Label5.AutoSize = $true
$Label5.width = 25
$Label5.height = 10
$Label5.location = New-Object System.Drawing.Point(116,230)
$Label5.Font = 'Microsoft Sans Serif,10'
$Label5.Visible = $false

$Label6 = New-Object system.Windows.Forms.Label
$Label6.text = "Recovery Key for C:"
$Label6.AutoSize = $true
$Label6.width = 25
$Label6.height = 10
$Label6.location = New-Object System.Drawing.Point(159,180)
$Label6.Font = 'Microsoft Sans Serif,10'
$label6.ForeColor = "Red"
$label6.Visible = $false

$Label7 = New-Object system.Windows.Forms.Label
$Label7.AutoSize = $true
$Label7.width = 25
$Label7.height = 10
$Label7.location = New-Object System.Drawing.Point(159,280)
$Label7.Font = 'Microsoft Sans Serif,10'
$label7.Visible = $false


$img1 = [System.Drawing.Image]::FromFile($fl1)
$PictureBox1 = New-Object System.Windows.Forms.PictureBox
$PictureBox1.AutoSize = $false
$PictureBox1.Location = New-Object System.Drawing.Point(29,70)
$PictureBox1.Image = $img1
$PictureBox1.Width = $img1.Width/12
$PictureBox1.Height = $img1.Height/12
$PictureBox1.SizeMode = "Zoom"

$img2 = [System.Drawing.Image]::FromFile($fl2)
$PictureBox2 = New-Object System.Windows.Forms.PictureBox
$PictureBox2.AutoSize = $false
$PictureBox2.Location = New-Object System.Drawing.Point(347,70)
$PictureBox2.Image = $img2
$PictureBox2.Width = $img2.Width/12
$PictureBox2.Height = $img2.Height/12
$PictureBox2.SizeMode = "Zoom"

$img3 = [System.Drawing.Image]::FromFile($fl3)
$PictureBox3 = New-Object System.Windows.Forms.PictureBox
$PictureBox3.AutoSize = $false
$PictureBox3.Location = New-Object System.Drawing.Point(187,70)
$PictureBox3.Image = $img3
$PictureBox3.Width = $img3.Width/12
$PictureBox3.Height = $img3.Height/12
$PictureBox3.SizeMode = "Zoom"

$TextBox1 = New-Object system.Windows.Forms.TextBox
$TextBox1.multiline = $false
$TextBox1.width = 350
$TextBox1.height = 20
$TextBox1.location = New-Object System.Drawing.Point(35,250)
$TextBox1.Font = 'Microsoft Sans Serif,10'
$TextBox1.Visible = $false

$TextBox2 = New-Object system.Windows.Forms.TextBox
$TextBox2.multiline = $false
$TextBox2.width = 372
$TextBox2.height = 20
$TextBox2.location = New-Object System.Drawing.Point(35,200)
$TextBox2.Font = 'Microsoft Sans Serif,10'
$TextBox2.AutoSize = $true
$TextBox2.ReadOnly = $true
$TextBox2.ForeColor = "Red"
$TextBox2.Visible = $false


$img4 = [System.Drawing.Image]::FromFile($fl4)
$Button3 = New-Object system.Windows.Forms.Button
$Button3.BackgroundImage = $img4
$Button3.BackgroundImageLayout = [System.Windows.Forms.ImageLayout]::Zoom
$Button3.width = 20
$Button3.height = 25
$Button3.add_click({
    [System.Windows.forms.clipboard]::SetText($TextBox2.Text.Trim())
})
$Button3.location = New-Object System.Drawing.Point(415,199)
$Button3.Visible = $false

$img5 = [System.Drawing.Image]::FromFile($fl4)
$Button4 = New-Object system.Windows.Forms.Button
$Button4.BackgroundImage = $img5
$Button4.BackgroundImageLayout = [System.Windows.Forms.ImageLayout]::Zoom
$Button4.width = 20
$Button4.height = 25
$Button4.add_click({
    [System.Windows.forms.clipboard]::SetText($TextBox1.Text.Trim())
})
$Button4.location = New-Object System.Drawing.Point(415,249)
$Button4.Visible = $false

$Button6 = New-Object system.Windows.Forms.Button
$Button6.Text = "#"
$Button6.width = 20
$Button6.height = 25
$Button6.add_click({
    Add-Type -AssemblyName "System.Web"
    $TextBox1.Text = [System.Web.Security.Membership]::GeneratePassword(10,0)
})
$Button6.location = New-Object System.Drawing.Point(392,249)
$Button6.Visible = $false

$Button2 = New-Object system.Windows.Forms.Button
$Button2.text = "Close"
$Button2.width = 70
$Button2.height = 30
$Button2.location = New-Object System.Drawing.Point(326,137)
$Button2.Font = 'Microsoft Sans Serif,10'
$Button2.Add_Click({
    $Form.Close()
})

$Button1 = New-Object system.Windows.Forms.Button
$Button1.text = "Continue"
$Button1.width = 70
$Button1.height = 30
$Button1.location = New-Object System.Drawing.Point(47,137)
$Button1.Font = 'Microsoft Sans Serif,10'
$Button1.Enabled = $decr_c
$Button1.Add_Click({
    $button1.Enabled = $false
    
    write-host "eject all removeble media"
    $vol= (Get-WmiObject -Class Win32_Volume | where {($_.drivetype -eq '2') -or ($_.drivetype -eq '5')}  )
    $Eject =  New-Object -comObject Shell.Application
    $Eject.NameSpace(17).ParseName($vol.driveletter).InvokeVerb("Eject")

    Add-BitLockerKeyProtector -MountPoint "C:" -RecoveryPasswordProtector -WarningVariable "one"
    $one[0] -match "(\d{6}(-\d{6}){7})"
    $Matches[0] | Set-Content $env:COMPUTERNAME.txt
    if (Test-Path "$env:SYSTEMROOT\System32\Recovery\REAgent.xml") {
        if (Test-Path "$env:SYSTEMROOT\System32\Recovery\REAgent.old") {
            Remove-Item -Path "$env:SYSTEMROOT\System32\Recovery\REAgent.old" -Force
        }
        Rename-Item -Path "$env:SYSTEMROOT\System32\Recovery\REAgent.xml" -NewName "$env:SYSTEMROOT\System32\Recovery\REAgent.old" -Force
    }
    if ($efi) {
        if ($tpm) {
            $form.ClientSize = "450,250"
            $Label6.Visible = $true
            $Button3.Visible = $true
            $TextBox1.Visible = $false
            $TextBox2.Visible = $true
            $TextBox2.Text = $Matches[0].Trim()
            $Button5.Visible = $false
            $Button6.Visible = $false
            Initialize-Tpm -AllowClear -AllowPhysicalPresence -ErrorAction SilentlyContinue
            $button2.Enabled = $false
            Write-Host "enabling bitlocker with tpm only"
            Enable-BitLocker -MountPoint "C:" -TpmProtector -UsedSpaceOnly -ErrorAction SilentlyContinue
            $button2.Enabled = $true
            if ($LASTEXITCODE) {
                $label7.Visible = $true
                $label7.Text = "Something went wrong!"
                $label7.ForeColor = "Red"
                $label7.location = New-Object System.Drawing.Point(159,135)
            } else {
                $label7.Visible = $true
                $label7.Text = "Done!`r`nReboot this PC!"
                $label7.TextAlign = "MiddleCenter"
                $label7.ForeColor = "Green"
                $label7.location = New-Object System.Drawing.Point(159,135)
            }
        } else {
            $form.ClientSize = "450,350"
            $Button2.location = New-Object System.Drawing.Point(326,300)
            $Button3.Visible = $true
            $Button4.Visible = $true
            $TextBox2.Visible = $true
            $TextBox2.Text = $Matches[0].Trim()
            $TextBox1.Visible = $true
            $Label6.Visible = $true
            $Label5.Visible = $true
            $Button5.Visible = $true
            $Button6.Visible = $true
        }
    } else {
        $form.ClientSize = "450,350"
        $Button2.location = New-Object System.Drawing.Point(326,300)
        $Button3.Visible = $true
        $Button4.Visible = $true
        $TextBox2.Visible = $true
        $TextBox2.Text = $Matches[0].Trim()    
        $TextBox1.Visible = $true
        $Label6.Visible = $true
        $Label5.Visible = $true
        $Button5.Visible = $true
        $Button6.Visible = $true
    }
})

$Button5 = New-Object system.Windows.Forms.Button
$Button5.text = "Correct"
$Button5.width = 70
$Button5.height = 30
$Button5.location = New-Object System.Drawing.Point(47,300)
$Button5.Font = 'Microsoft Sans Serif,10'
$Button5.Add_Click({
    $pass = $TextBox1.Text.Trim()
    $label7.Visible = $true
    if (($pass -eq "") -or ($pass -eq $null)) {
        $label7.Text = "Field can't be empty!"
        $label7.ForeColor = "Red"
    } else {
        $label7.Text = ""
        $pass | Set-Content "${env:COMPUTERNAME}_passwd.txt"
        $passwd = ConvertTo-SecureString $pass  -AsPlainText -force
        $button2.Enabled = $false
        $button5.Enabled = $false
        write-host "Enabling Bitlocker with password olny"
        Enable-BitLocker -MountPoint "C:" -PasswordProtector -UsedSpaceOnly -Password $passwd -EncryptionMethod Aes256 -ErrorAction SilentlyContinue
        $button2.Enabled = $true
        if ($LASTEXITCODE) {
            $label7.Text = "Something went wrong!"
            $label7.ForeColor = "Red"
        } else {
            $label7.Text = "Done!`r`nReboot this PC!"
            $label7.TextAlign = "MiddleCenter"
            $label7.ForeColor = "Green"
            $label7.location = New-Object System.Drawing.Point(159,298)
        }
    }
})

$Form.controls.AddRange(@($Label1,$Label2,$Label3,$label4,$PictureBox1,$PictureBox2,$PictureBox3,$Button1,$Button2,$Label5,$Label6,$label7,$TextBox1,$textbox2,$Button3,$button4,$button5,$button6))

$Form.ShowDialog() | Out-Null

Stop-Transcript
