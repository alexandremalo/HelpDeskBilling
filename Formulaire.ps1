[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[System.Windows.Forms.Application]::EnableVisualStyles()
[System.Globalization.NumberFormatInfo]::CurrentInfo.NumberDecimalSeparator = '.'

$csv = "C:\Script\users.csv"
$facturationCSV = "C:\Script\codes.csv"
$IncidentsCSV = "C:\Script\incidents.csv"
$factures = "C:\Script\factures.csv"
$taxesCSV = "C:\Script\taxes.csv"
$fichierIncident = "C:\Script\template-incident.xlsx"
$fichierFacture = "C:\Script\template-facture.xlsx"
$destinationFichiers = "C:\Script\Dossiers Clients\"

$AllUsers = Import-Csv -Encoding Default $csv
$CodesCSV = Import-Csv $facturationCSV
$Incidents = Import-Csv -Delimiter ';' -Encoding Unicode $IncidentsCSV
$ListeFacture = Import-Csv -Delimiter ';' $factures
$taxes = Import-Csv $taxesCSV


$objForm = New-Object System.Windows.Forms.Form 
$objForm.Text = "Gestion Client"
$objForm.Size = New-Object System.Drawing.Size(1100,900) 
$objForm.StartPosition = "CenterScreen"
$objForm.BackColor = [System.Drawing.Color]::LightSlateGray
$objForm.MaximizeBox = $false
$objForm.FormBorderStyle = 'Fixed3D'



$Font = New-Object System.Drawing.Font("Times New Roman",25,[System.Drawing.FontStyle]::Regular)
$FontPetit = New-Object System.Drawing.Font("Times New Roman",18,[System.Drawing.FontStyle]::Regular)

$objForm.Font = $Font

$objForm.KeyPreview = $True
#$objForm.Add_KeyDown({if ($_.KeyCode -eq "Enter") 
#    {$x=$objTextBox.Text;$objForm.Close()}})
$objForm.Add_KeyDown({if ($_.KeyCode -eq "Escape") 
    {$objForm.Close()}})

#Groupe ClientInfo
$GroupBoxClient = New-Object System.Windows.Forms.GroupBox
$GroupBoxClient.Location = New-Object System.Drawing.Size(0,50)
$GroupBoxClient.Size = New-Object System.Drawing.Size(1090,360)
$objForm.Controls.Add($GroupBoxClient)

#Groupe Problemes
$GroupBoxIncident = New-Object System.Windows.Forms.GroupBox
$GroupBoxIncident.Location = New-Object System.Drawing.Size(0,400)
$GroupBoxIncident.Size = New-Object System.Drawing.Size(1090,360)
$objForm.Controls.Add($GroupBoxIncident)

#Groupe Factures
$GroupBoxFacture = New-Object System.Windows.Forms.GroupBox
$GroupBoxFacture.Location = New-Object System.Drawing.Size(0,400)
$GroupBoxFacture.Size = New-Object System.Drawing.Size(1090,360)
$GroupBoxFacture.Visible = $false
$objForm.Controls.Add($GroupBoxFacture)


#Groupe Question
$YesNoGroupBox = New-Object System.Windows.Forms.GroupBox
$YesNoGroupBox.Location = New-Object System.Drawing.Size(10,150)
$YesNoGroupBox.TabIndex = 20
$YesNoGroupBox.Size = New-Object System.Drawing.Size(300,200)
$GroupBoxIncident.Controls.Add($YesNoGroupBox)

#Nouveau client
$NouveauClientCheckBox = New-Object System.Windows.Forms.CheckBox 
$NouveauClientCheckBox.Location = New-Object System.Drawing.Size(10,10)
$NouveauClientCheckBox.TabIndex = 200
$NouveauClientCheckBox.Size = New-Object System.Drawing.Size(300,40)
$NouveauClientCheckBox.Text = "Nouveau client"
$NouveauClientCheckBox.BackColor = 'DarkGray'
$objForm.Controls.Add($NouveauClientCheckBox)
$NouveauClientCheckBox.add_CheckedChanged({
    #clearclientinfo
    if($NouveauClientCheckBox.Checked -eq $True){
        $ClientExistantCheckBox.Checked = $False
        $NouveauClientCheckBox.BackColor = 'DarkGray'
        $ListeClientComboBox.Visible = $false
        $ListeClientComboBox.Items.Clear()
        $PrenomBox.Text = "Prénom"
        $PrenomBox.ForeColor = 'DarkGray'
        $NomBox.Text = "Nom"
        $NomBox.ForeColor = 'DarkGray'
        $Phone1Box.Text = "(450)890-4005"
        $Phone1Box.ForeColor = 'DarkGray'
        $Phone2Box.Text = "(844)287-6468"
        $Phone2Box.ForeColor = 'DarkGray'
        $PaysBox.Text = "Canada"
        $ProvinceBox.Text = "Québec"
        $CourrielBox.Text = "Courriel"
        $CourrielBox.ForeColor = 'DarkGray'
        $RueBox.Text = "4172 Grande-Allée"
        $RueBox.ForeColor = 'Darkgray'
        $CPBoc.Text = "J4V 3N2"
        $CPBoc.ForeColor = 'DarkGray'
        $VilleComboBox.Focus()
        $VilleComboBox.SelectedIndex = -1
        $NouveauClientCheckBox.Focus()
        
    }
    if($NouveauClientCheckBox.Checked -eq $False){
        $ClientExistantCheckBox.Checked = $True
        $NouveauClientCheckBox.BackColor = 'LightGray'
        $ListeClientComboBox.Visible = $true
        
    }
})
$NouveauClientCheckBox.Checked = $true

#Client Existant
$ClientExistantCheckBox = New-Object System.Windows.Forms.CheckBox 
$ClientExistantCheckBox.Location = New-Object System.Drawing.Size(350,10)
$ClientExistantCheckBox.Size = New-Object System.Drawing.Size(300,40)
$ClientExistantCheckBox.Text = "Client Existant"
$ClientExistantCheckBox.TabIndex = 201
$objForm.Controls.Add($ClientExistantCheckBox)
$ClientExistantCheckBox.add_CheckedChanged({
    #clearclientinfo
    if($ClientExistantCheckBox.Checked -eq $True){
        $NouveauClientCheckBox.Checked = $False
        $ClientExistantCheckBox.BackColor = 'DarkGray'
        $ListeClientComboBox.Visible = $true
        $AllUsers = Import-Csv -Encoding Default $csv
        $AllUsers | ForEach-Object {$ListeClientComboBox.Items.add($_.Prenom +" "+$_.Nom) > $null}
    }
    if($ClientExistantCheckBox.Checked -eq $False){
        $NouveauClientCheckBox.Checked = $True
        $ClientExistantCheckBox.BackColor = 'LightGray'
        $ListeClientComboBox.Visible = $false
    }
})

#Bouton Facture (en haut a droite)
$FactureCheckBox = New-Object System.Windows.Forms.CheckBox 
$FactureCheckBox.Location = New-Object System.Drawing.Size(900,10)
$FactureCheckBox.Size = New-Object System.Drawing.Size(190,40)
$FactureCheckBox.BackColor = 'Gray'
$FactureCheckBox.TabIndex = 202
$FactureCheckBox.Text = "Facturation"
$objForm.Controls.Add($FactureCheckBox)
$FactureCheckBox.add_CheckedChanged({
    #clearclientinfo
    if($FactureCheckBox.Checked -eq $True)
    {
        $GroupBoxIncident.Visible = $false
        $GroupBoxFacture.Visible = $true
        $FactureCheckBox.BackColor = 'DarkRed'
        $FactureCode1ComboBox.Focus()
    }
    if($FactureCheckBox.Checked -eq $False)
    {
        $GroupBoxFacture.Visible = $false
        $GroupBoxIncident.Visible = $true
        $FactureCheckBox.BackColor = 'Gray'
    }
})

#ListeClient
$ListeClientComboBox = New-Object System.Windows.Forms.ComboBox
$ListeClientComboBox.Location = New-Object System.Drawing.Point(200, 25)
$ListeClientComboBox.Size = New-Object System.Drawing.Size(550, 250)
$ListeClientComboBox.Sorted = $True
$ListeClientComboBox.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
$GroupBoxClient.Controls.Add($ListeClientComboBox)
$ListeClientComboBox.Visible = $false
$ListeClientComboBox.add_SelectedIndexChanged({
    if($ClientExistantCheckBox.checked)
    {
        $AllUsers = Import-Csv -Encoding Default $csv
        $selecteduser = $AllUsers | Where-Object {($_.Prenom -eq (($ListeClientComboBox.SelectedItem).split(''))[0]) -and ($_.Nom -eq (($ListeClientComboBox.SelectedItem).split(''))[1])}
        $PrenomBox.Text = $selecteduser.Prenom
        $PrenomBox.ForeColor = 'Black'
        $NomBox.Text = $selecteduser.Nom
        $NomBox.ForeColor = 'Black'
        $CourrielBox.Text = $selecteduser.Email
        $CourrielBox.ForeColor = 'Black'
        $CPboc.Text = $selecteduser.CodePostal
        $CPboc.ForeColor = 'Black'
        $VilleComboBox.items.Remove("Ville")
        $VilleComboBox.Text = $selecteduser.Ville
        if($VilleComboBox.Text -ne "N/A"){$VilleComboBox.ForeColor = 'Black'}
        $RueBox.Text = $selecteduser.Rue
        $RueBox.ForeColor = 'Black'
        $ProvinceBox.Text = $selecteduser.Province
        $PaysBox.Text = $selecteduser.Pays
        $Phone1Box.Text = $selecteduser.Tel1
        $Phone1Box.ForeColor = 'Black'
        $Phone2Box.Text = $selecteduser.Tel2
        $Phone2Box.ForeColor = 'Black'
    }
})


#Info Client
$InfoClientLabel = New-Object System.Windows.Forms.Label
$InfoClientLabel.Location = New-Object System.Drawing.Size(10,25) 
$InfoClientLabel.Size = New-Object System.Drawing.Size(175,35) 
$InfoClientLabel.Text = "Info Client:"
$GroupBoxClient.Controls.Add($InfoClientLabel)


#Prenom
$PrenomBox = New-Object System.Windows.Forms.TextBox 
$PrenomBox.Location = New-Object System.Drawing.Size(10,75)
$PrenomBox.BackColor = [System.Drawing.Color]::LightCyan
#$PrenomBox.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$PrenomBox.Size = New-Object System.Drawing.Size(400,20)
$PrenomBox.Add_LostFocus({
    if($PrenomBox.Text -eq "")
    {
        $PrenomBox.Text = "Prénom"
        $PrenomBox.ForeColor = 'DarkGray'
    }
})
$PrenomBox.Add_GotFocus({
    if($PrenomBox.Text -eq "Prénom" -and $PrenomBox.ForeColor -eq 'DarkGray')
    {
        $PrenomBox.Text = ""
        $PrenomBox.ForeColor = 'Black'
    }
})
$PrenomBox.Text = ""
$GroupBoxClient.Controls.Add($PrenomBox)

#Nom
$NomBox = New-Object System.Windows.Forms.TextBox 
$NomBox.Location = New-Object System.Drawing.Size(420,75)
$NomBox.BackColor = [System.Drawing.Color]::LightCyan 
$NomBox.Size = New-Object System.Drawing.Size(400,20)
$NomBox.Add_LostFocus({
    if($NomBox.Text -eq "")
    {
        $NomBox.Text = "Nom"
        $NomBox.ForeColor = 'DarkGray'
    }
})
$NomBox.Add_GotFocus({
    if($NomBox.Text -eq "Nom" -and $NomBox.ForeColor -eq 'DarkGray')
    {
        $NomBox.Text = ""
        $NomBox.ForeColor = 'Black'
    }
})
$NomBox.Text = "Nom"
$NomBox.ForeColor = 'DarkGray'
$GroupBoxClient.Controls.Add($NomBox)


#Phone1
$Phone1Box = New-Object System.Windows.Forms.TextBox 
$Phone1Box.Location = New-Object System.Drawing.Size(830,75) 
$Phone1Box.Size = New-Object System.Drawing.Size(250,20)
$Phone1Box.MaxLength = 13
$Phone1Box.BackColor = [System.Drawing.Color]::LightCyan
$Phone1Box.Add_TextChanged({
    if(($Phone1Box.Text).Length -ge 1 -and ($Phone1Box.Text).Length -le 3 -and ($Phone1Box.text)[0] -ne '(')
    {
        $Phone1Box.Text = "("+($Phone1Box.Text)
        $Phone1Box.SelectionStart = 13
    }
    elseif(($Phone1Box.Text).Length -eq 5 -and ($Phone1Box.text)[0] -eq '(' -and ($Phone1Box.text)[4] -ne ')')
    {
        $Phone1Box.Text = "("+($Phone1Box.text)[1]+($Phone1Box.text)[2]+($Phone1Box.text)[3] + ")" + ($Phone1Box.text)[4]
        $Phone1Box.SelectionStart = 13
    }
    elseif(($Phone1Box.Text).Length -eq 9 -and ($Phone1Box.text)[0] -eq '(' -and ($Phone1Box.text)[4] -eq ')' -and ($Phone1Box.text)[8] -ne '-')
    {
        $Phone1Box.Text = "("+($Phone1Box.text)[1]+($Phone1Box.text)[2]+($Phone1Box.text)[3] + ")" + ($Phone1Box.text)[5] + ($Phone1Box.text)[6] + ($Phone1Box.text)[7] + "-" + ($Phone1Box.text)[8]
        $Phone1Box.SelectionStart = 13
    }
})
$Phone1Box.Add_LostFocus({
    if($Phone1Box.Text -eq "")
    {
        $Phone1Box.Text = "(450)890-4005"
        $Phone1Box.ForeColor = 'DarkGray'
    }
})
$Phone1Box.Add_GotFocus({
    if($Phone1Box.Text -eq "(450)890-4005" -and $Phone1Box.ForeColor -eq 'DarkGray')
    {
        $Phone1Box.Text = ""
        $Phone1Box.ForeColor = 'Black'
    }
})
$Phone1Box.Text = "(450)890-4005"
$Phone1Box.ForeColor = 'DarkGray'
$GroupBoxClient.Controls.Add($Phone1Box)

#Courriel
$CourrielBox = New-Object System.Windows.Forms.TextBox 
$CourrielBox.Location = New-Object System.Drawing.Size(10,130) 
$CourrielBox.Size = New-Object System.Drawing.Size(810,20)
$CourrielBox.BackColor = [System.Drawing.Color]::LightCyan
$CourrielBox.Add_LostFocus({
    if($CourrielBox.Text -eq "")
    {
        $CourrielBox.Text = "Courriel"
        $CourrielBox.ForeColor = 'DarkGray'
    }
})
$CourrielBox.Add_GotFocus({
    if($CourrielBox.Text -eq "Courriel" -and $CourrielBox.ForeColor -eq 'DarkGray')
    {
        $CourrielBox.Text = ""
        $CourrielBox.ForeColor = 'Black'
    }
})
$CourrielBox.Text = "Courriel"
$CourrielBox.ForeColor = 'DarkGray'
$GroupBoxClient.Controls.Add($CourrielBox)

#Phone2
$Phone2Box = New-Object System.Windows.Forms.TextBox 
$Phone2Box.Location = New-Object System.Drawing.Size(830,130) 
$Phone2Box.Size = New-Object System.Drawing.Size(250,20)
$Phone2Box.MaxLength = 13
$Phone2Box.BackColor = [System.Drawing.Color]::LightCyan
$Phone2Box.Add_TextChanged({
    if(($Phone2Box.Text).Length -ge 1 -and ($Phone2Box.Text).Length -le 3 -and ($Phone2Box.text)[0] -ne '(' -and ($Phone2Box.text)[0] -ne "N")
    {
        $Phone2Box.Text = "("+($Phone2Box.Text)
        $Phone2Box.SelectionStart = 13
    }
    elseif(($Phone2Box.Text).Length -eq 5 -and ($Phone2Box.text)[0] -eq '(' -and ($Phone2Box.text)[4] -ne ')')
    {
        $Phone2Box.Text = "("+($Phone2Box.text)[1]+($Phone2Box.text)[2]+($Phone2Box.text)[3] + ")" + ($Phone2Box.text)[4]
        $Phone2Box.SelectionStart = 13
    }
    elseif(($Phone2Box.Text).Length -eq 9 -and ($Phone2Box.text)[0] -eq '(' -and ($Phone2Box.text)[4] -eq ')' -and ($Phone2Box.text)[8] -ne '-')
    {
        $Phone2Box.Text = "("+($Phone2Box.text)[1]+($Phone2Box.text)[2]+($Phone2Box.text)[3] + ")" + ($Phone2Box.text)[5] + ($Phone2Box.text)[6] + ($Phone2Box.text)[7] + "-" + ($Phone2Box.text)[8]
        $Phone2Box.SelectionStart = 13
    }
})
$Phone2Box.Add_LostFocus({
    if($Phone2Box.Text -eq "")
    {
        $Phone2Box.Text = "(844)287-6468"
        $Phone2Box.ForeColor = 'DarkGray'
    }
})
$Phone2Box.Add_GotFocus({
    if($Phone2Box.Text -eq "(844)287-6468" -and $Phone2Box.ForeColor -eq 'DarkGray')
    {
        $Phone2Box.Text = ""
        $Phone2Box.ForeColor = 'Black'
    }
})
$Phone2Box.Text = "(844)287-6468"
$Phone2Box.ForeColor = 'DarkGray'
$GroupBoxClient.Controls.Add($Phone2Box)





#Adresse
$AdresseLabel = New-Object System.Windows.Forms.Label
$AdresseLabel.Location = New-Object System.Drawing.Size(10,200) 
$AdresseLabel.Size = New-Object System.Drawing.Size(150,35) 
$AdresseLabel.Text = "Adresse:"
$GroupBoxClient.Controls.Add($AdresseLabel)


#Rue
$RueBox = New-Object System.Windows.Forms.TextBox 
$RueBox.Location = New-Object System.Drawing.Size(10,250) 
$RueBox.Size = New-Object System.Drawing.Size(950,20)
$RueBox.BackColor = [System.Drawing.Color]::LightCyan
$RueBox.Add_LostFocus({
    if($RueBox.Text -eq "")
    {
        $RueBox.Text = "4172 Grande-Allée"
        $RueBox.ForeColor = 'DarkGray'
    }
})
$RueBox.Add_GotFocus({
    if($RueBox.Text -eq "4172 Grande-Allée" -and $RueBox.ForeColor -eq 'DarkGray')
    {
        $RueBox.Text = ""
        $RueBox.ForeColor = 'Black'
    }
})
$RueBox.Text = "4172 Grande-Allée"
$RueBox.ForeColor = 'DarkGray'
$GroupBoxClient.Controls.Add($RueBox)


#Ville
$VilleComboBox = New-Object System.Windows.Forms.ComboBox
$VilleComboBox.Location = New-Object System.Drawing.Point(10, 305)
$VilleComboBox.Size = New-Object System.Drawing.Size(300, 250)
$VilleComboBox.Sorted = $True
$VilleComboBox.AutoCompleteMode = 'Append'
$VilleComboBox.AutoCompleteSource = 'ListItems'
$VilleComboBox.Items.add("Greenfield Park") > $null
$VilleComboBox.Items.add("Longueuil") > $null
$VilleComboBox.Items.add("Sainte-Julie") > $null
$VilleComboBox.Items.add("Saint-Hubert") > $null
$VilleComboBox.Items.add("Brossard") > $null
$VilleComboBox.Items.add("Boucherville") > $null
$VilleComboBox.Items.add("Varennes") > $null
$VilleComboBox.Items.add("Saint-Lambert") > $null
$VilleComboBox.Items.add("Montréal") > $null
$VilleComboBox.Items.Add("Ville") > $null
$VilleComboBox.SelectedItem = "Ville"
$VilleComboBox.ForeColor = 'DarkGray'
$VilleComboBox.add_SelectedIndexChanged({
    if($VilleComboBox.Text -eq "Ville" -or $VilleComboBox.SelectedIndex -eq -1)
    {
        $VilleComboBox.ForeColor = 'DarkGray'
    }
    else
    {
        $VilleComboBox.ForeColor = 'Black'
    }
})
$VilleComboBox.Add_LostFocus({
    if($VilleComboBox.Text -eq "")
    {
        $VilleComboBox.Items.Add("Ville") > $null
        $VilleComboBox.SelectedItem = "Ville"
        $VilleComboBox.ForeColor = 'DarkGray'
    }
    elseif($VilleComboBox.Text -ne "Ville"){
        $VilleComboBox.ForeColor = 'Black'
    }
})
$VilleComboBox.Add_GotFocus({
    if($VilleComboBox.Text -eq "N/A")
    {
        $VilleComboBox.Text = ""
        $VilleComboBox.ForeColor = 'Black'
    }
    if($VilleComboBox.Text -eq "Ville" -and $VilleComboBox.ForeColor -eq 'DarkGray')
    {
        $VilleComboBox.Items.Remove("Ville")
        $VilleComboBox.ForeColor = 'Black'
    }
})
$GroupBoxClient.Controls.Add($VilleComboBox)
$VilleComboBox.BackColor = [System.Drawing.Color]::LightCyan


#Code Postale
$CPBoc = New-Object System.Windows.Forms.TextBox 
$CPBoc.Location = New-Object System.Drawing.Size(320,305) 
$CPBoc.Size = New-Object System.Drawing.Size(220,20)
$CPBoc.MaxLength = 7
$CPBoc.BackColor = [System.Drawing.Color]::LightCyan
$CPBoc.Add_TextChanged({
    if(($CPBoc.Text).Length -ge 4 -and ($CPBoc.text)[3] -ne ' ')
    {
        $CPBoc.Text = ($CPBoc.text)[0] + ($CPBoc.text)[1] + ($CPBoc.text)[2] + " " + ($CPBoc.text)[3]
        $CPBoc.SelectionStart = 7
    }
})
$CPBoc.Add_LostFocus({
    if($CPBoc.Text -eq "")
    {
        $CPBoc.Text = "J4V 3N2"
        $CPBoc.ForeColor = 'DarkGray'
    }
})
$CPBoc.Add_GotFocus({
    if($CPBoc.Text -eq "J4V 3N2" -and $CPBoc.ForeColor -eq 'DarkGray')
    {
        $CPBoc.Text = ""
        $CPBoc.ForeColor = 'Black'
    }
})
$CPBoc.Text = "J4V 3N2"
$CPBoc.ForeColor = 'DarkGray'
$GroupBoxClient.Controls.Add($CPBoc)


#Province
$ProvinceBox = New-Object System.Windows.Forms.TextBox 
$ProvinceBox.Location = New-Object System.Drawing.Size(550,305) 
$ProvinceBox.Size = New-Object System.Drawing.Size(200,20)
$ProvinceBox.Text = "Québec"
$ProvinceBox.BackColor = [System.Drawing.Color]::LightCyan
$GroupBoxClient.Controls.Add($ProvinceBox)


#Pays
$PaysBox = New-Object System.Windows.Forms.TextBox 
$PaysBox.Location = New-Object System.Drawing.Size(760,305) 
$PaysBox.Size = New-Object System.Drawing.Size(200,20)
$PaysBox.Text = "Canada"
$PaysBox.BackColor = [System.Drawing.Color]::LightCyan
$GroupBoxClient.Controls.Add($PaysBox)




###
### Section Incident
###



#Details de l'incident
$IncidentBox = New-Object System.Windows.Forms.TextBox 
$IncidentBox.Location = New-Object System.Drawing.Size(10,30) 
$IncidentBox.Size = New-Object System.Drawing.Size(1070,60)
$IncidentBox.Font = $FontPetit
$IncidentBox.TabIndex = 13
$IncidentBox.MaxLength = 232
$IncidentBox.BackColor = [System.Drawing.Color]::LightCyan
$IncidentBox.ScrollBars = [System.Windows.Forms.ScrollBars]::Vertical
$IncidentBox.Multiline = $True
$IncidentBox.Add_LostFocus({
    if($IncidentBox.Text -eq "")
    {
        $IncidentBox.Text = "Description du problème"
        $IncidentBox.ForeColor = 'DarkGray'
    }
})
$IncidentBox.Add_GotFocus({
    if($IncidentBox.Text -eq "Description du problème" -and $IncidentBox.ForeColor -eq 'DarkGray')
    {
        $IncidentBox.Text = ""
        $IncidentBox.ForeColor = 'Black'
    }
})
$IncidentBox.Text = "Description du problème"
$IncidentBox.ForeColor = 'DarkGray'
$GroupBoxIncident.Controls.Add($IncidentBox)


#Marque
$MarqueBox = New-Object System.Windows.Forms.TextBox 
$MarqueBox.Location = New-Object System.Drawing.Size(10,100) 
$MarqueBox.Size = New-Object System.Drawing.Size(300,20)
$MarqueBox.TabIndex = 14
$MarqueBox.BackColor = [System.Drawing.Color]::LightCyan
$MarqueBox.Add_LostFocus({
    if($MarqueBox.Text -eq "")
    {
        $MarqueBox.Text = "Marque"
        $MarqueBox.ForeColor = 'DarkGray'
    }
})
$MarqueBox.Add_GotFocus({
    if($MarqueBox.Text -eq "Marque" -and $MarqueBox.ForeColor -eq 'DarkGray')
    {
        $MarqueBox.Text = ""
        $MarqueBox.ForeColor = 'Black'
    }
})
$MarqueBox.Text = "Marque"
$MarqueBox.ForeColor = 'DarkGray'
$GroupBoxIncident.Controls.Add($MarqueBox)


#Modèle
$ModeleBox = New-Object System.Windows.Forms.TextBox 
$ModeleBox.Location = New-Object System.Drawing.Size(320,100) 
$ModeleBox.Size = New-Object System.Drawing.Size(300,20)
$ModeleBox.TabIndex = 15
$ModeleBox.BackColor = [System.Drawing.Color]::LightCyan
$ModeleBox.Add_LostFocus({
    if($ModeleBox.Text -eq "")
    {
        $ModeleBox.Text = "Modèle"
        $ModeleBox.ForeColor = 'DarkGray'
    }
})
$ModeleBox.Add_GotFocus({
    if($ModeleBox.Text -eq "Modèle" -and $ModeleBox.ForeColor -eq 'DarkGray')
    {
        $ModeleBox.Text = ""
        $ModeleBox.ForeColor = 'Black'
    }
})
$ModeleBox.Text = "Modèle"
$ModeleBox.ForeColor = 'DarkGray'
$GroupBoxIncident.Controls.Add($ModeleBox)


#No Série
$NSBox = New-Object System.Windows.Forms.TextBox 
$NSBox.Location = New-Object System.Drawing.Size(630,100) 
$NSBox.Size = New-Object System.Drawing.Size(450,20)
$NSBox.TabIndex = 16
$NSBox.BackColor = [System.Drawing.Color]::LightCyan
$NSBox.Add_LostFocus({
    if($NSBox.Text -eq "")
    {
        $NSBox.Text = "Numéro de Série"
        $NSBox.ForeColor = 'DarkGray'
    }
})
$NSBox.Add_GotFocus({
    if($NSBox.Text -eq "Numéro de Série" -and $NSBox.ForeColor -eq 'DarkGray')
    {
        $NSBox.Text = ""
        $NSBox.ForeColor = 'Black'
    }
})
$NSBox.Text = "Numéro de Série"
$NSBox.ForeColor = 'DarkGray'
$GroupBoxIncident.Controls.Add($NSBox)


#Mot de Passe
$MDPBox = New-Object System.Windows.Forms.TextBox 
$MDPBox.Location = New-Object System.Drawing.Size(320,200) 
$MDPBox.Size = New-Object System.Drawing.Size(300,20)
$MDPBox.TabIndex = 21
$MDPBox.BackColor = [System.Drawing.Color]::LightCyan
$MDPBox.Add_LostFocus({
    if($MDPBox.Text -eq "")
    {
        $MDPBox.Text = "Mot de passe"
        $MDPBox.ForeColor = 'DarkGray'
    }
})
$MDPBox.Add_GotFocus({
    if($MDPBox.Text -eq "Mot de passe" -and $MDPBox.ForeColor -eq 'DarkGray')
    {
        $MDPBox.Text = ""
        $MDPBox.ForeColor = 'Black'
    }
})
$MDPBox.Text = "Mot de passe"
$MDPBox.ForeColor = 'DarkGray'
$GroupBoxIncident.Controls.Add($MDPBox)


#Langue
$LangueBox = New-Object System.Windows.Forms.ComboBox 
$LangueBox.Location = New-Object System.Drawing.Size(320,300) 
$LangueBox.Size = New-Object System.Drawing.Size(300,20)
$LangueBox.items.add("Francais") > $null
$LangueBox.TabIndex = 22
$LangueBox.items.add("Anglais") > $null
$LangueBox.SelectedItem = "Francais"
$LangueBox.BackColor = [System.Drawing.Color]::LightCyan
$GroupBoxIncident.Controls.Add($LangueBox)


#Autres Informations
$AutresInfosBox = New-Object System.Windows.Forms.TextBox 
$AutresInfosBox.Location = New-Object System.Drawing.Size(630,155) 
$AutresInfosBox.Size = New-Object System.Drawing.Size(450,190)
$AutresInfosBox.Font = $FontPetit
$AutresInfosBox.TabIndex = 23
$AutresInfosBox.BackColor = [System.Drawing.Color]::LightCyan
$AutresInfosBox.ScrollBars = [System.Windows.Forms.ScrollBars]::Vertical
$AutresInfosBox.Multiline = $True
$AutresInfosBox.Add_LostFocus({
    if($AutresInfosBox.Text -eq "")
    {
        $AutresInfosBox.Text = "Équipements additionnels"
        $AutresInfosBox.ForeColor = 'DarkGray'
    }
})
$AutresInfosBox.Add_GotFocus({
    if($AutresInfosBox.Text -eq "Équipements additionnels" -and $AutresInfosBox.ForeColor -eq 'DarkGray')
    {
        $AutresInfosBox.Text = ""
        $AutresInfosBox.ForeColor = 'Black'
    }
})
$AutresInfosBox.Text = "Équipements additionnels"
$AutresInfosBox.ForeColor = 'DarkGray'
$GroupBoxIncident.Controls.Add($AutresInfosBox)


#Information Importante Label
$InfoImportanteLabel = New-Object System.Windows.Forms.Label
$InfoImportanteLabel.Location = New-Object System.Drawing.Size(10,25) 
$InfoImportanteLabel.Size = New-Object System.Drawing.Size(280,35) 
$InfoImportanteLabel.Text = "Données importantes ?"
$InfoImportanteLabel.Font = $FontPetit
$YesNoGroupBox.Controls.Add($InfoImportanteLabel)

#Information Importante OUI
$InfoImportanteOUICheckBox = New-Object System.Windows.Forms.CheckBox 
$InfoImportanteOUICheckBox.Location = New-Object System.Drawing.Size(10,60)
$InfoImportanteOUICheckBox.Text = "OUI"
$InfoImportanteOUICheckBox.TabIndex = 17
$InfoImportanteOUICheckBox.Add_LostFocus({
    if($InfoImportanteOUICheckBox.Checked){
    $CordonAlimentationOUICheckBox.Focus()}
})
$InfoImportanteOUICheckBox.Font = $FontPetit
$YesNoGroupBox.Controls.Add($InfoImportanteOUICheckBox)
$InfoImportanteOUICheckBox.add_CheckedChanged({
    if($InfoImportanteOUICheckBox.Checked -eq $True){
        $InfoImportanteNONCheckBox.Checked = $False
    }
})

#Information Importante NON
$InfoImportanteNONCheckBox = New-Object System.Windows.Forms.CheckBox 
$InfoImportanteNONCheckBox.Location = New-Object System.Drawing.Size(130,60)
$InfoImportanteNONCheckBox.Text = "NON"
$InfoImportanteOUICheckBox.TabIndex = 18
$InfoImportanteNONCheckBox.Font = $FontPetit
$YesNoGroupBox.Controls.Add($InfoImportanteNONCheckBox)
$InfoImportanteNONCheckBox.add_CheckedChanged({
    if($InfoImportanteNONCheckBox.Checked -eq $True){
        $InfoImportanteOUICheckBox.Checked = $False
    }
})



#Cordon Alimentation Label
$CordonAlimentationLabel = New-Object System.Windows.Forms.Label
$CordonAlimentationLabel.Location = New-Object System.Drawing.Size(10,125) 
$CordonAlimentationLabel.Size = New-Object System.Drawing.Size(280,35) 
$CordonAlimentationLabel.Text = "Cordon d'alimentation ?"
$CordonAlimentationLabel.Font = $FontPetit
$YesNoGroupBox.Controls.Add($CordonAlimentationLabel)

#Information Importante OUI
$CordonAlimentationOUICheckBox = New-Object System.Windows.Forms.CheckBox 
$CordonAlimentationOUICheckBox.Location = New-Object System.Drawing.Size(10,160)
$CordonAlimentationOUICheckBox.Text = "OUI"
$CordonAlimentationOUICheckBox.TabIndex = 19
$CordonAlimentationOUICheckBox.Add_LostFocus({
    if($CordonAlimentationOUICheckBox.Checked){
    $MDPBox.Focus()}
})
$CordonAlimentationOUICheckBox.Font = $FontPetit
$YesNoGroupBox.Controls.Add($CordonAlimentationOUICheckBox)
$CordonAlimentationOUICheckBox.add_CheckedChanged({
    if($CordonAlimentationOUICheckBox.Checked -eq $True){
        $CordonAlimentationNONCheckBox.Checked = $False
    }
})

#Information Importante NON
$CordonAlimentationNONCheckBox = New-Object System.Windows.Forms.CheckBox 
$CordonAlimentationNONCheckBox.Location = New-Object System.Drawing.Size(130,160)
$CordonAlimentationNONCheckBox.Text = "NON"
$CordonAlimentationNONCheckBox.TabIndex = 20
$CordonAlimentationNONCheckBox.Font = $FontPetit
$YesNoGroupBox.Controls.Add($CordonAlimentationNONCheckBox)
$CordonAlimentationNONCheckBox.add_CheckedChanged({
    if($CordonAlimentationNONCheckBox.Checked -eq $True){
        $CordonAlimentationOUICheckBox.Checked = $False
    }
})


#PremierCode (SKU_1)
$FactureCode1ComboBox = New-Object System.Windows.Forms.ComboBox
$FactureCode1ComboBox.Location = New-Object System.Drawing.Point(10, 25)
$FactureCode1ComboBox.Size = New-Object System.Drawing.Size(150, 250)
$FactureCode1ComboBox.Sorted = $True
$FactureCode1ComboBox.AutoCompleteMode = 'Append'
$FactureCode1ComboBox.AutoCompleteSource = 'ListItem'
$CodesCSV | ForEach-Object {$FactureCode1ComboBox.Items.Add(""+$_.ID) > $null}
$FactureCode1ComboBox.add_SelectedIndexChanged({
    if($FactureCode1ComboBox.SelectedIndex -ne -1)
    {
        $FactureDescription1Box.Text = ($CodesCSV | Where-Object {$_.ID -eq $FactureCode1ComboBox.SelectedItem}).Description
        $FactureDescription1Box.ForeColor = 'Black'
        $Prix1Box.Text = "{0:N2}" -f ([Float]($CodesCSV | Where-Object {$_.ID -eq $FactureCode1ComboBox.SelectedItem}).Prix)
        $Rabais1Box.Value = 0
    }
})
$GroupBoxFacture.Controls.Add($FactureCode1ComboBox)
$FactureCode1ComboBox.BackColor = [System.Drawing.Color]::LightCyan

#Description1
$FactureDescription1Box = New-Object System.Windows.Forms.TextBox
$FactureDescription1Box.Location = New-Object System.Drawing.Size(170,25) 
$FactureDescription1Box.Size = New-Object System.Drawing.Size(670,190)
$FactureDescription1Box.BackColor = [System.Drawing.Color]::LightCyan
$FactureDescription1Box.Add_LostFocus({
    if($FactureDescription1Box.Text -eq "")
    {
        $FactureDescription1Box.Text = "Description"
        $FactureDescription1Box.ForeColor = 'DarkGray'
    }
})
$FactureDescription1Box.Add_GotFocus({
    if($FactureCode1ComboBox.SelectedItem -ne "1000" -and $FactureCode1ComboBox.SelectedIndex -ne -1)
    {
            $FactureCode2ComboBox.Focus()
    }
    if($FactureDescription1Box.Text -eq "Description" -and $FactureDescription1Box.ForeColor -eq 'DarkGray')
    {
        $FactureDescription1Box.Text = ""
        $FactureDescription1Box.ForeColor = 'Black'
        
    }
})
$FactureDescription1Box.Text = "Description"
$FactureDescription1Box.ForeColor = 'DarkGray'
$GroupBoxFacture.Controls.Add($FactureDescription1Box)

#Symbole de Cash 1
$MoneySymbol = New-Object System.Windows.Forms.Label
$MoneySymbol.Location = New-Object System.Drawing.Size(844,29)
$MoneySymbol.Size = New-Object System.Drawing.Size(22,35) 
$MoneySymbol.Text = "$"
$GroupBoxFacture.Controls.Add($MoneySymbol)

#Numeric Prix 1
$Prix1Box = New-Object System.Windows.Forms.TextBox
$Prix1Box.Location = New-Object System.Drawing.Size(870,25)
$Prix1Box.Size = New-Object System.Drawing.Size(138,190)
$Prix1Box.MaxLength = 8
$Prix1Box.Text = "0.00"
$Prix1Box.add_TextChanged({
    $textavantmodif = $Prix1Box.Text
    $Prix1Box.Text = $Prix1Box.Text -replace '[^1234567890.]'
    if($textavantmodif -ne $Prix1Box.Text){
        $Prix1Box.Select(($Prix1Box.Text).Length,0)}
    $tempSousTotal = ((([FLOAT]($Prix1Box.text)) + ([FLOAT]($Prix2Box.text)) + ([FLOAT]($Prix3Box.text)) + ([FLOAT]($Prix4Box.text)) + ([FLOAT]($Prix5Box.text))))
    #$tempRabais = ($RabaisPourcentageBox.Value /100)
    #$tempSousTotal = ($tempSousTotal - ($tempSousTotal * $tempRabais))
    $TVQCashTotalBox.Value = $tempSousTotal * (([FLOAT]($taxes | Where-Object {$_.Name -eq "Taxes"}).TVQ)/100)
    $TPSCashTotalBox.Value = $tempSousTotal * (([FLOAT]($taxes | Where-Object {$_.Name -eq "Taxes"}).TPS)/100)
    $PrixTotalBox.Value = $tempSousTotal + $TPSCashTotalBox.Value + $TVQCashTotalBox.Value
})
$Prix1Box.add_LostFocus({
    $Prix1Box.Text = ("{0:N2}" -f [Float]($Prix1Box.Text)).ToString($Formatvirgule)
})
$Prix1Box.BackColor = [System.Drawing.Color]::LightCyan
$GroupBoxFacture.Controls.Add($Prix1Box)


#PremierCode (SKU_2)
$FactureCode2ComboBox = New-Object System.Windows.Forms.ComboBox
$FactureCode2ComboBox.Location = New-Object System.Drawing.Point(10, 75)
$FactureCode2ComboBox.Size = New-Object System.Drawing.Size(150, 250)
$FactureCode2ComboBox.Sorted = $True
$FactureCode2ComboBox.AutoCompleteMode = 'Append'
$FactureCode2ComboBox.AutoCompleteSource = 'ListItem'
$CodesCSV | ForEach-Object {$FactureCode2ComboBox.Items.Add(""+$_.ID) > $null}
$FactureCode2ComboBox.add_SelectedIndexChanged({
    if($FactureCode2ComboBox.SelectedIndex -ne -1)
    {
        $FactureDescription2Box.Text = ($CodesCSV | Where-Object {$_.ID -eq $FactureCode2ComboBox.SelectedItem}).Description
        $FactureDescription2Box.ForeColor = 'Black'
        $Prix2Box.Text = "{0:N2}" -f ([Float]($CodesCSV | Where-Object {$_.ID -eq $FactureCode2ComboBox.SelectedItem}).Prix)
        $Rabais2Box.Value = 0
    }
})
$GroupBoxFacture.Controls.Add($FactureCode2ComboBox)
$FactureCode2ComboBox.BackColor = [System.Drawing.Color]::LightCyan

#Description2
$FactureDescription2Box = New-Object System.Windows.Forms.TextBox 
$FactureDescription2Box.Location = New-Object System.Drawing.Size(170,75) 
$FactureDescription2Box.Size = New-Object System.Drawing.Size(670,190)
$FactureDescription2Box.BackColor = [System.Drawing.Color]::LightCyan
$FactureDescription2Box.Add_LostFocus({
    if($FactureDescription2Box.Text -eq "")
    {
        $FactureDescription2Box.Text = "Description"
        $FactureDescription2Box.ForeColor = 'DarkGray'
    }
})
$FactureDescription2Box.Add_GotFocus({
    if($FactureCode2ComboBox.SelectedItem -ne "1000" -and $FactureCode2ComboBox.SelectedIndex -ne -1)
    {
            $FactureCode3ComboBox.Focus()
    }
    if($FactureDescription2Box.Text -eq "Description" -and $FactureDescription2Box.ForeColor -eq 'DarkGray')
    {
        $FactureDescription2Box.Text = ""
        $FactureDescription2Box.ForeColor = 'Black'
    }
})
$FactureDescription2Box.Text = "Description"
$FactureDescription2Box.ForeColor = 'DarkGray'
$GroupBoxFacture.Controls.Add($FactureDescription2Box)

#Symbole de Cash 2
$MoneySymbol2 = New-Object System.Windows.Forms.Label
$MoneySymbol2.Location = New-Object System.Drawing.Size(844,79) 
$MoneySymbol2.Size = New-Object System.Drawing.Size(22,35) 
$MoneySymbol2.Text = "$"
$GroupBoxFacture.Controls.Add($MoneySymbol2)

#Numeric Prix 2
$Prix2Box = New-Object System.Windows.Forms.TextBox
$Prix2Box.Location = New-Object System.Drawing.Size(870,75) 
$Prix2Box.Size = New-Object System.Drawing.Size(138,190)
$Prix2Box.MaxLength = 8
$Prix2Box.Text = "0.00"
$Prix2Box.add_TextChanged({
    $textavantmodif = $Prix2Box.Text
    $Prix2Box.Text = $Prix2Box.Text -replace '[^1234567890.]'
    if($textavantmodif -ne $Prix2Box.Text){
        $Prix2Box.Select(($Prix2Box.Text).Length,0)}
    $tempSousTotal = ((([FLOAT]($Prix1Box.text)) + ([FLOAT]($Prix2Box.text)) + ([FLOAT]($Prix3Box.text)) + ([FLOAT]($Prix4Box.text)) + ([FLOAT]($Prix5Box.text))))
    #$tempRabais = ($RabaisPourcentageBox.Value /100)
    #$tempSousTotal = ($tempSousTotal - ($tempSousTotal * $tempRabais))
    $TVQCashTotalBox.Value = $tempSousTotal * (([FLOAT]($taxes | Where-Object {$_.Name -eq "Taxes"}).TVQ)/100)
    $TPSCashTotalBox.Value = $tempSousTotal * (([FLOAT]($taxes | Where-Object {$_.Name -eq "Taxes"}).TPS)/100)
    $PrixTotalBox.Value = $tempSousTotal + $TPSCashTotalBox.Value + $TVQCashTotalBox.Value
})
$Prix2Box.add_LostFocus({
    $Prix2Box.Text = ("{0:N2}" -f [Float]($Prix2Box.Text)).ToString($Formatvirgule)
})
$Prix2Box.BackColor = [System.Drawing.Color]::LightCyan
$GroupBoxFacture.Controls.Add($Prix2Box)


#PremierCode (SKU_3)
$FactureCode3ComboBox = New-Object System.Windows.Forms.ComboBox
$FactureCode3ComboBox.Location = New-Object System.Drawing.Point(10, 125)
$FactureCode3ComboBox.Size = New-Object System.Drawing.Size(150, 250)
$FactureCode3ComboBox.Sorted = $True
$FactureCode3ComboBox.AutoCompleteMode = 'Append'
$FactureCode3ComboBox.AutoCompleteSource = 'ListItem'
$CodesCSV | ForEach-Object {$FactureCode3ComboBox.Items.Add(""+$_.ID) > $null}
$FactureCode3ComboBox.add_SelectedIndexChanged({
    if($FactureCode3ComboBox.SelectedIndex -ne -1)
    {
        $FactureDescription3Box.Text = ($CodesCSV | Where-Object {$_.ID -eq $FactureCode3ComboBox.SelectedItem}).Description
        $FactureDescription3Box.ForeColor = 'Black'
        $Prix3Box.Text = "{0:N2}" -f ([Float]($CodesCSV | Where-Object {$_.ID -eq $FactureCode3ComboBox.SelectedItem}).Prix)
        $Rabais3Box.Value = 0
    }
})
$GroupBoxFacture.Controls.Add($FactureCode3ComboBox)
$FactureCode3ComboBox.BackColor = [System.Drawing.Color]::LightCyan

#Description3
$FactureDescription3Box = New-Object System.Windows.Forms.TextBox 
$FactureDescription3Box.Location = New-Object System.Drawing.Size(170,125) 
$FactureDescription3Box.Size = New-Object System.Drawing.Size(670,190)
$FactureDescription3Box.BackColor = [System.Drawing.Color]::LightCyan
$FactureDescription3Box.Add_LostFocus({
    if($FactureDescription3Box.Text -eq "")
    {
        $FactureDescription3Box.Text = "Description"
        $FactureDescription3Box.ForeColor = 'DarkGray'
    }
})
$FactureDescription3Box.Add_GotFocus({
    if($FactureCode3ComboBox.SelectedItem -ne "1000" -and $FactureCode3ComboBox.SelectedIndex -ne -1)
    {
            $FactureCode4ComboBox.Focus()
    }
    if($FactureDescription3Box.Text -eq "Description" -and $FactureDescription3Box.ForeColor -eq 'DarkGray')
    {
        $FactureDescription3Box.Text = ""
        $FactureDescription3Box.ForeColor = 'Black'
    }
})
$FactureDescription3Box.Text = "Description"
$FactureDescription3Box.ForeColor = 'DarkGray'
$GroupBoxFacture.Controls.Add($FactureDescription3Box)

#Symbole de Cash 3
$MoneySymbol3 = New-Object System.Windows.Forms.Label
$MoneySymbol3.Location = New-Object System.Drawing.Size(844,129) 
$MoneySymbol3.Size = New-Object System.Drawing.Size(22,35) 
$MoneySymbol3.Text = "$"
$GroupBoxFacture.Controls.Add($MoneySymbol3)

#Numeric Prix 3
$Prix3Box = New-Object System.Windows.Forms.TextBox
$Prix3Box.Location = New-Object System.Drawing.Size(870,125) 
$Prix3Box.Size = New-Object System.Drawing.Size(138,190)
$Prix3Box.MaxLength = 8
$Prix3Box.Text = "0.00"
$Prix3Box.add_TextChanged({
    $textavantmodif = $Prix3Box.Text
    $Prix3Box.Text = $Prix3Box.Text -replace '[^1234567890.]'
    if($textavantmodif -ne $Prix3Box.Text){
        $Prix3Box.Select(($Prix3Box.Text).Length,0)}
    $tempSousTotal = ((([FLOAT]($Prix1Box.text)) + ([FLOAT]($Prix2Box.text)) + ([FLOAT]($Prix3Box.text)) + ([FLOAT]($Prix4Box.text)) + ([FLOAT]($Prix5Box.text))))
    #$tempRabais = ($RabaisPourcentageBox.Value /100)
    #$tempSousTotal = ($tempSousTotal - ($tempSousTotal * $tempRabais))
    $TVQCashTotalBox.Value = $tempSousTotal * (([FLOAT]($taxes | Where-Object {$_.Name -eq "Taxes"}).TVQ)/100)
    $TPSCashTotalBox.Value = $tempSousTotal * (([FLOAT]($taxes | Where-Object {$_.Name -eq "Taxes"}).TPS)/100)
    $PrixTotalBox.Value = $tempSousTotal + $TPSCashTotalBox.Value + $TVQCashTotalBox.Value
})
$Prix3Box.add_LostFocus({
    $Prix3Box.Text = ("{0:N2}" -f [Float]($Prix3Box.Text)).ToString($Formatvirgule)
})
$Prix3Box.BackColor = [System.Drawing.Color]::LightCyan
$GroupBoxFacture.Controls.Add($Prix3Box)


#PremierCode (SKU_4)
$FactureCode4ComboBox = New-Object System.Windows.Forms.ComboBox
$FactureCode4ComboBox.Location = New-Object System.Drawing.Point(10, 175)
$FactureCode4ComboBox.Size = New-Object System.Drawing.Size(150, 250)
$FactureCode4ComboBox.Sorted = $True
$FactureCode4ComboBox.AutoCompleteMode = 'Append'
$FactureCode4ComboBox.AutoCompleteSource = 'ListItem'
$CodesCSV | ForEach-Object {$FactureCode4ComboBox.Items.Add(""+$_.ID) > $null}
$FactureCode4ComboBox.add_SelectedIndexChanged({
    if($FactureCode4ComboBox.SelectedIndex -ne -1)
    {
        $FactureDescription4Box.Text = ($CodesCSV | Where-Object {$_.ID -eq $FactureCode4ComboBox.SelectedItem}).Description
        $FactureDescription4Box.ForeColor = 'Black'
        $Prix4Box.Text = "{0:N2}" -f ([Float]($CodesCSV | Where-Object {$_.ID -eq $FactureCode4ComboBox.SelectedItem}).Prix)
        $Rabais4Box.Value = 0
    }
})
$GroupBoxFacture.Controls.Add($FactureCode4ComboBox)
$FactureCode4ComboBox.BackColor = [System.Drawing.Color]::LightCyan

#Description4
$FactureDescription4Box = New-Object System.Windows.Forms.TextBox 
$FactureDescription4Box.Location = New-Object System.Drawing.Size(170,175) 
$FactureDescription4Box.Size = New-Object System.Drawing.Size(670,190)
$FactureDescription4Box.BackColor = [System.Drawing.Color]::LightCyan
$FactureDescription4Box.Add_LostFocus({
    if($FactureDescription4Box.Text -eq "")
    {
        $FactureDescription4Box.Text = "Description"
        $FactureDescription4Box.ForeColor = 'DarkGray'
    }
})
$FactureDescription4Box.Add_GotFocus({
    if($FactureCode4ComboBox.SelectedItem -ne "1000" -and $FactureCode4ComboBox.SelectedIndex -ne -1)
    {
            $FactureCode5ComboBox.Focus()
    }
    if($FactureDescription4Box.Text -eq "Description" -and $FactureDescription4Box.ForeColor -eq 'DarkGray')
    {
        $FactureDescription4Box.Text = ""
        $FactureDescription4Box.ForeColor = 'Black'
    }
})
$FactureDescription4Box.Text = "Description"
$FactureDescription4Box.ForeColor = 'DarkGray'
$GroupBoxFacture.Controls.Add($FactureDescription4Box)

#Symbole de Cash 4
$MoneySymbol4 = New-Object System.Windows.Forms.Label
$MoneySymbol4.Location = New-Object System.Drawing.Size(844,179) 
$MoneySymbol4.Size = New-Object System.Drawing.Size(22,35) 
$MoneySymbol4.Text = "$"
$GroupBoxFacture.Controls.Add($MoneySymbol4)

#Numeric Prix 4
$Prix4Box = New-Object System.Windows.Forms.TextBox
$Prix4Box.Location = New-Object System.Drawing.Size(870,175) 
$Prix4Box.Size = New-Object System.Drawing.Size(138,190)
$Prix4Box.MaxLength = 8
$Prix4Box.Text = "0.00"
$Prix4Box.add_TextChanged({
    $textavantmodif = $Prix4Box.Text
    $Prix4Box.Text = $Prix4Box.Text -replace '[^1234567890.]'
    if($textavantmodif -ne $Prix4Box.Text){
        $Prix4Box.Select(($Prix4Box.Text).Length,0)}
    $tempSousTotal = ((([FLOAT]($Prix1Box.text)) + ([FLOAT]($Prix2Box.text)) + ([FLOAT]($Prix3Box.text)) + ([FLOAT]($Prix4Box.text)) + ([FLOAT]($Prix5Box.text))))
    #$tempRabais = ($RabaisPourcentageBox.Value /100)
    #$tempSousTotal = ($tempSousTotal - ($tempSousTotal * $tempRabais))
    $TVQCashTotalBox.Value = $tempSousTotal * (([FLOAT]($taxes | Where-Object {$_.Name -eq "Taxes"}).TVQ)/100)
    $TPSCashTotalBox.Value = $tempSousTotal * (([FLOAT]($taxes | Where-Object {$_.Name -eq "Taxes"}).TPS)/100)
    $PrixTotalBox.Value = $tempSousTotal + $TPSCashTotalBox.Value + $TVQCashTotalBox.Value
})
$Prix4Box.add_LostFocus({
    $Prix4Box.Text = ("{0:N2}" -f [Float]($Prix4Box.Text)).ToString($Formatvirgule)
})
$Prix4Box.BackColor = [System.Drawing.Color]::LightCyan
$GroupBoxFacture.Controls.Add($Prix4Box)


#PremierCode (SKU_5)
$FactureCode5ComboBox = New-Object System.Windows.Forms.ComboBox
$FactureCode5ComboBox.Location = New-Object System.Drawing.Point(10, 225)
$FactureCode5ComboBox.Size = New-Object System.Drawing.Size(150, 250)
$FactureCode5ComboBox.Sorted = $True
$FactureCode5ComboBox.AutoCompleteMode = 'Append'
$FactureCode5ComboBox.AutoCompleteSource = 'ListItem'
$CodesCSV | ForEach-Object {$FactureCode5ComboBox.Items.Add(""+$_.ID) > $null}
$FactureCode5ComboBox.add_SelectedIndexChanged({
    if($FactureCode5ComboBox.SelectedIndex -ne -1)
    {
        $FactureDescription5Box.Text = ($CodesCSV | Where-Object {$_.ID -eq $FactureCode5ComboBox.SelectedItem}).Description
        $FactureDescription5Box.ForeColor = 'Black'
        $Prix5Box.Text = "{0:N2}" -f ([Float]($CodesCSV | Where-Object {$_.ID -eq $FactureCode5ComboBox.SelectedItem}).Prix)
        $Rabais5Box.Value = 0
    }
})
$GroupBoxFacture.Controls.Add($FactureCode5ComboBox)
$FactureCode5ComboBox.BackColor = [System.Drawing.Color]::LightCyan

#Description5
$FactureDescription5Box = New-Object System.Windows.Forms.TextBox 
$FactureDescription5Box.Location = New-Object System.Drawing.Size(170,225) 
$FactureDescription5Box.Size = New-Object System.Drawing.Size(670,190)
$FactureDescription5Box.BackColor = [System.Drawing.Color]::LightCyan
$FactureDescription5Box.Add_LostFocus({
    if($FactureDescription5Box.Text -eq "")
    {
        $FactureDescription5Box.Text = "Description"
        $FactureDescription5Box.ForeColor = 'DarkGray'
    }
})
$FactureDescription5Box.Add_GotFocus({
    if($FactureCode5ComboBox.SelectedItem -ne "1000" -and $FactureCode5ComboBox.SelectedIndex -ne -1)
    {
            $OKButton.Focus()
    }
    if($FactureDescription5Box.Text -eq "Description" -and $FactureDescription5Box.ForeColor -eq 'DarkGray')
    {
        $FactureDescription5Box.Text = ""
        $FactureDescription5Box.ForeColor = 'Black'
    }
})
$FactureDescription5Box.Text = "Description"
$FactureDescription5Box.ForeColor = 'DarkGray'
$GroupBoxFacture.Controls.Add($FactureDescription5Box)

#Symbole de Cash 5
$MoneySymbol5 = New-Object System.Windows.Forms.Label
$MoneySymbol5.Location = New-Object System.Drawing.Size(844,229) 
$MoneySymbol5.Size = New-Object System.Drawing.Size(22,35) 
$MoneySymbol5.Text = "$"
$GroupBoxFacture.Controls.Add($MoneySymbol5)

#Numeric Prix 5
$Prix5Box = New-Object System.Windows.Forms.TextBox
$Prix5Box.Location = New-Object System.Drawing.Size(870,225) 
$Prix5Box.Size = New-Object System.Drawing.Size(138,190)
$Prix5Box.MaxLength = 8
$Prix5Box.Text = "0.00"
$Prix5Box.add_TextChanged({
    $textavantmodif = $Prix5Box.Text
    $Prix5Box.Text = $Prix5Box.Text -replace '[^1234567890.]'
    if($textavantmodif -ne $Prix5Box.Text){
        $Prix5Box.Select(($Prix5Box.Text).Length,0)}
    $tempSousTotal = ((([FLOAT]($Prix1Box.text)) + ([FLOAT]($Prix2Box.text)) + ([FLOAT]($Prix3Box.text)) + ([FLOAT]($Prix4Box.text)) + ([FLOAT]($Prix5Box.text))))
    $tempRabais = ($RabaisPourcentageBox.Value /100)
    $tempSousTotal = ($tempSousTotal - ($tempSousTotal * $tempRabais))
    $TVQCashTotalBox.Value = $tempSousTotal * (([FLOAT]($taxes | Where-Object {$_.Name -eq "Taxes"}).TVQ)/100)
    $TPSCashTotalBox.Value = $tempSousTotal * (([FLOAT]($taxes | Where-Object {$_.Name -eq "Taxes"}).TPS)/100)
    $PrixTotalBox.Value = $tempSousTotal + $TPSCashTotalBox.Value + $TVQCashTotalBox.Value
})
$Prix5Box.add_LostFocus({
    $Prix5Box.Text = ("{0:N2}" -f [Float]($Prix5Box.Text)).ToString($Formatvirgule)
})
$Prix5Box.BackColor = [System.Drawing.Color]::LightCyan
$GroupBoxFacture.Controls.Add($Prix5Box)


#Rabais Boxes 1
$Rabais1Symbole = New-Object System.Windows.Forms.Label
$Rabais1Symbole.Location = New-Object System.Drawing.Size(1047,33) 
$Rabais1Symbole.Size = New-Object System.Drawing.Size(24,30)
$Rabais1Symbole.Font = $FontPetit
$Rabais1Symbole.BackColor = "White"
$Rabais1Symbole.Text = "%"
$GroupBoxFacture.Controls.Add($Rabais1Symbole)

$Rabais1Box = New-Object System.Windows.Forms.NumericUpDown
$Rabais1Box.Location = New-Object System.Drawing.Size(1010,31)
$Rabais1Box.TabStop = $false
$Rabais1Box.Size = New-Object System.Drawing.Size(79,190)
$Rabais1Box.DecimalPlaces = 0
$Rabais1Box.Font = $FontPetit
$Rabais1Box.Maximum = 100
$Rabais1Box.Add_ValueChanged({
    if($FactureCode1ComboBox.SelectedIndex -ne -1 -and $FactureCode1ComboBox.SelectedText -ne "1000")
    {
        $prixSansRabais = ([Float]($CodesCSV | Where-Object {$_.ID -eq $FactureCode1ComboBox.SelectedItem}).Prix)
        $tempRabais = ($Rabais1Box.Value /100)
        $tempSousTotal = ($prixSansRabais - ($prixSansRabais * $tempRabais))
        $Prix1Box.text = "{0:N2}" -f [math]::round($tempSousTotal,2)
    }
})
$GroupBoxFacture.Controls.Add($Rabais1Box)

#Rabais Boxes 2
$Rabais2Symbole = New-Object System.Windows.Forms.Label
$Rabais2Symbole.Location = New-Object System.Drawing.Size(1047,83) 
$Rabais2Symbole.Size = New-Object System.Drawing.Size(24,30)
$Rabais2Symbole.Font = $FontPetit
$Rabais2Symbole.BackColor = "White"
$Rabais2Symbole.Text = "%"
$GroupBoxFacture.Controls.Add($Rabais2Symbole)

$Rabais2Box = New-Object System.Windows.Forms.NumericUpDown
$Rabais2Box.Location = New-Object System.Drawing.Size(1010,81)
$Rabais2Box.TabStop = $false
$Rabais2Box.Size = New-Object System.Drawing.Size(79,190)
$Rabais2Box.DecimalPlaces = 0
$Rabais2Box.Font = $FontPetit
$Rabais2Box.Maximum = 100
$Rabais2Box.Add_ValueChanged({
    if($FactureCode2ComboBox.SelectedIndex -ne -1 -and $FactureCode2ComboBox.SelectedText -ne "1000")
    {
        $prixSansRabais = ([Float]($CodesCSV | Where-Object {$_.ID -eq $FactureCode2ComboBox.SelectedItem}).Prix)
        $tempRabais = ($Rabais2Box.Value /100)
        $tempSousTotal = ($prixSansRabais - ($prixSansRabais * $tempRabais))
        $Prix2Box.text = "{0:N2}" -f [math]::round($tempSousTotal,2)
    }
})
$GroupBoxFacture.Controls.Add($Rabais2Box)

#Rabais Boxes 3
$Rabais3Symbole = New-Object System.Windows.Forms.Label
$Rabais3Symbole.Location = New-Object System.Drawing.Size(1047,133) 
$Rabais3Symbole.Size = New-Object System.Drawing.Size(24,30)
$Rabais3Symbole.Font = $FontPetit
$Rabais3Symbole.BackColor = "White"
$Rabais3Symbole.Text = "%"
$GroupBoxFacture.Controls.Add($Rabais3Symbole)

$Rabais3Box = New-Object System.Windows.Forms.NumericUpDown
$Rabais3Box.Location = New-Object System.Drawing.Size(1010,131)
$Rabais3Box.TabStop = $false
$Rabais3Box.Size = New-Object System.Drawing.Size(79,190)
$Rabais3Box.DecimalPlaces = 0
$Rabais3Box.Font = $FontPetit
$Rabais3Box.Maximum = 100
$Rabais3Box.Add_ValueChanged({
    if($FactureCode3ComboBox.SelectedIndex -ne -1 -and $FactureCode3ComboBox.SelectedText -ne "1000")
    {
        $prixSansRabais = ([Float]($CodesCSV | Where-Object {$_.ID -eq $FactureCode3ComboBox.SelectedItem}).Prix)
        $tempRabais = ($Rabais3Box.Value /100)
        $tempSousTotal = ($prixSansRabais - ($prixSansRabais * $tempRabais))
        $Prix3Box.text = "{0:N2}" -f [math]::round($tempSousTotal,2)
    }
})
$GroupBoxFacture.Controls.Add($Rabais3Box)

#Rabais Boxes 4
$Rabais4Symbole = New-Object System.Windows.Forms.Label
$Rabais4Symbole.Location = New-Object System.Drawing.Size(1047,183) 
$Rabais4Symbole.Size = New-Object System.Drawing.Size(24,30)
$Rabais4Symbole.Font = $FontPetit
$Rabais4Symbole.BackColor = "White"
$Rabais4Symbole.Text = "%"
$GroupBoxFacture.Controls.Add($Rabais4Symbole)

$Rabais4Box = New-Object System.Windows.Forms.NumericUpDown
$Rabais4Box.Location = New-Object System.Drawing.Size(1010,181)
$Rabais4Box.TabStop = $false
$Rabais4Box.Size = New-Object System.Drawing.Size(79,190)
$Rabais4Box.DecimalPlaces = 0
$Rabais4Box.Font = $FontPetit
$Rabais4Box.Maximum = 100
$Rabais4Box.Add_ValueChanged({
    if($FactureCode4ComboBox.SelectedIndex -ne -1 -and $FactureCode4ComboBox.SelectedText -ne "1000")
    {
        $prixSansRabais = ([Float]($CodesCSV | Where-Object {$_.ID -eq $FactureCode4ComboBox.SelectedItem}).Prix)
        $tempRabais = ($Rabais4Box.Value /100)
        $tempSousTotal = ($prixSansRabais - ($prixSansRabais * $tempRabais))
        $Prix4Box.text = "{0:N2}" -f [math]::round($tempSousTotal,2)
    }
})
$GroupBoxFacture.Controls.Add($Rabais4Box)

#Rabais Boxes 5
$Rabais5Symbole = New-Object System.Windows.Forms.Label
$Rabais5Symbole.Location = New-Object System.Drawing.Size(1047,233) 
$Rabais5Symbole.Size = New-Object System.Drawing.Size(24,30)
$Rabais5Symbole.Font = $FontPetit
$Rabais5Symbole.BackColor = "White"
$Rabais5Symbole.Text = "%"
$GroupBoxFacture.Controls.Add($Rabais5Symbole)

$Rabais5Box = New-Object System.Windows.Forms.NumericUpDown
$Rabais5Box.Location = New-Object System.Drawing.Size(1010,231)
$Rabais5Box.TabStop = $false
$Rabais5Box.Size = New-Object System.Drawing.Size(79,190)
$Rabais5Box.DecimalPlaces = 0
$Rabais5Box.Font = $FontPetit
$Rabais5Box.Maximum = 100
$Rabais5Box.Add_ValueChanged({
    if($FactureCode5ComboBox.SelectedIndex -ne -1 -and $FactureCode5ComboBox.SelectedText -ne "1000")
    {
        $prixSansRabais = ([Float]($CodesCSV | Where-Object {$_.ID -eq $FactureCode5ComboBox.SelectedItem}).Prix)
        $tempRabais = ($Rabais5Box.Value /100)
        $tempSousTotal = ($prixSansRabais - ($prixSansRabais * $tempRabais))
        $Prix5Box.text = "{0:N2}" -f [math]::round($tempSousTotal,2)
    }
})
$GroupBoxFacture.Controls.Add($Rabais5Box)

#TPS Label
$TPSFactureLabel = New-Object System.Windows.Forms.Label
$TPSFactureLabel.Location = New-Object System.Drawing.Size(10,279) 
$TPSFactureLabel.Size = New-Object System.Drawing.Size(115,35)
$TPSFactureLabel.Font = $FontPetit
$TPSFactureLabel.Text = "TPS :    %"
$GroupBoxFacture.Controls.Add($TPSFactureLabel)

#TVQ Label
$TVQFactureLabel = New-Object System.Windows.Forms.Label
$TVQFactureLabel.Location = New-Object System.Drawing.Size(10,320) 
$TVQFactureLabel.Size = New-Object System.Drawing.Size(115,35)
$TVQFactureLabel.Font = $FontPetit
$TVQFactureLabel.Text = "TVQ :   %"
$GroupBoxFacture.Controls.Add($TVQFactureLabel)


#Total Label
$TotalFactureLabel = New-Object System.Windows.Forms.Label
$TotalFactureLabel.Location = New-Object System.Drawing.Size(695,279) 
$TotalFactureLabel.Size = New-Object System.Drawing.Size(150,35) 
$TotalFactureLabel.Text = "TOTAL :   $"
$GroupBoxFacture.Controls.Add($TotalFactureLabel)

#Symbole de Cash 5
$MoneySymbolTotal = New-Object System.Windows.Forms.Label
$MoneySymbolTotal.Location = New-Object System.Drawing.Size(844,279) 
$MoneySymbolTotal.Size = New-Object System.Drawing.Size(23,35) 
$MoneySymbolTotal.Text = "$"
$GroupBoxFacture.Controls.Add($MoneySymbolTotal)


#TPS Numeric Box
$TPSTotalBox = New-Object System.Windows.Forms.NumericUpDown
$TPSTotalBox.Location = New-Object System.Drawing.Size(130,275)
$TPSTotalBox.TabStop = $false
$TPSTotalBox.Size = New-Object System.Drawing.Size(100,190)
$TPSTotalBox.DecimalPlaces = 2
$TPSTotalBox.BackColor = 'DarkGray'
$TPSTotalBox.Increment = 0
$TPSTotalBox.Value = ($taxes | Where-Object {$_.Name -eq "Taxes"}).TPS
$TPSTotalBox.ReadOnly = $True
$TPSTotalBox.Font = $FontPetit
$TPSTotalBox.BackColor = [System.Drawing.Color]::DarkGray
$TPSTotalBox.Maximum = 9999
$GroupBoxFacture.Controls.Add($TPSTotalBox)

#TVQ Numeric Box
$TVQTotalBox = New-Object System.Windows.Forms.NumericUpDown
$TVQTotalBox.Location = New-Object System.Drawing.Size(130,315) 
$TVQTotalBox.Size = New-Object System.Drawing.Size(100,190)
$TVQTotalBox.TabStop = $false
$TVQTotalBox.DecimalPlaces = 2
$TVQTotalBox.BackColor = 'DarkGray'
$TVQTotalBox.ReadOnly = $true
$TVQTotalBox.Increment = 0
$TVQTotalBox.Value = ($taxes | Where-Object {$_.Name -eq "Taxes"}).TVQ
$TVQTotalBox.Font = $FontPetit
$TVQTotalBox.BackColor = [System.Drawing.Color]::DarkGray
$TVQTotalBox.Maximum = 9999999
$GroupBoxFacture.Controls.Add($TVQTotalBox)


#TPS Label
$CashSymboleTPS = New-Object System.Windows.Forms.Label
$CashSymboleTPS.Location = New-Object System.Drawing.Size(270,279) 
$CashSymboleTPS.Size = New-Object System.Drawing.Size(30,35)
$CashSymboleTPS.Font = $FontPetit
$CashSymboleTPS.Text = "$"
$GroupBoxFacture.Controls.Add($CashSymboleTPS)

#TVQ Label
$CashSymboleTVQ = New-Object System.Windows.Forms.Label
$CashSymboleTVQ.Location = New-Object System.Drawing.Size(270,320) 
$CashSymboleTVQ.Size = New-Object System.Drawing.Size(30,35)
$CashSymboleTVQ.Font = $FontPetit
$CashSymboleTVQ.Text = "$"
$GroupBoxFacture.Controls.Add($CashSymboleTVQ)

#TPS Numeric Box
$TPSCashTotalBox = New-Object System.Windows.Forms.NumericUpDown
$TPSCashTotalBox.Location = New-Object System.Drawing.Size(300,275) 
$TPSCashTotalBox.Size = New-Object System.Drawing.Size(100,190)
$TPSCashTotalBox.DecimalPlaces = 4
$TPSCashTotalBox.TabStop = $false
$TPSCashTotalBox.BackColor = 'DarkGray'
$TPSCashTotalBox.Increment = 0
$TPSCashTotalBox.ReadOnly = $True
$TPSCashTotalBox.Font = $FontPetit
$TPSCashTotalBox.BackColor = [System.Drawing.Color]::DarkGray
$TPSCashTotalBox.Maximum = 999999
$GroupBoxFacture.Controls.Add($TPSCashTotalBox)

#TVQ Numeric Box
$TVQCashTotalBox = New-Object System.Windows.Forms.NumericUpDown
$TVQCashTotalBox.Location = New-Object System.Drawing.Size(300,315) 
$TVQCashTotalBox.Size = New-Object System.Drawing.Size(100,190)
$TVQCashTotalBox.DecimalPlaces = 4
$TVQCashTotalBox.TabStop = $false
$TVQCashTotalBox.BackColor = 'DarkGray'
$TVQCashTotalBox.ReadOnly = $true
$TVQCashTotalBox.Increment = 0
$TVQCashTotalBox.Font = $FontPetit
$TVQCashTotalBox.BackColor = [System.Drawing.Color]::DarkGray
$TVQCashTotalBox.Maximum = 999
$GroupBoxFacture.Controls.Add($TVQCashTotalBox)



#Total Numeric Box
$PrixTotalBox = New-Object System.Windows.Forms.NumericUpDown
$PrixTotalBox.Location = New-Object System.Drawing.Size(870,275) 
$PrixTotalBox.Size = New-Object System.Drawing.Size(220,190)
$PrixTotalBox.DecimalPlaces = 2
$PrixTotalBox.TabStop = $false
$PrixTotalBox.Increment = 0
$PrixTotalBox.BackColor = [System.Drawing.Color]::DarkGray
$PrixTotalBox.ReadOnly = $true
$PrixTotalBox.Maximum = 999999
$GroupBoxFacture.Controls.Add($PrixTotalBox)


#Cancel Bouton
$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.TabIndex = 100
$CancelButton.Location = New-Object System.Drawing.Size(550,770)
$CancelButton.Size = New-Object System.Drawing.Size(200,90)
$CancelButton.Text = "Clear"
$CancelButton.Add_Click({
    $NomBox.BackColor = [System.Drawing.Color]::LightCyan
    $PrenomBox.BackColor = [System.Drawing.Color]::LightCyan
    $Phone1Box.BackColor = [System.Drawing.Color]::LightCyan
    $YesNoGroupBox.BackColor = [System.Drawing.Color]::LightSlateGray
    $IncidentBox.BackColor = [System.Drawing.Color]::LightCyan
    $MarqueBox.BackColor = [System.Drawing.Color]::LightCyan
    $PrixTotalBox.ForeColor = 'Black'
    $PrenomBox.focus()
    $PrenomBox.Text = ""
    $NomBox.focus()
    $NomBox.Text = ""
    $RueBox.Focus()
    $RueBox.Text = ""
    $Phone1Box.focus()
    $Phone1Box.Text = ""
    $Phone2Box.focus()
    $Phone2Box.Text = ""
    $CourrielBox.focus()
    $CourrielBox.Text = ""
    $VilleComboBox.Focus()
    $VilleComboBox.Text = ""
    $CPBoc.focus()
    $CPBoc.Text = ""
    $PaysBox.Text = "Canada"
    $ProvinceBox.Text = "Québec"
    
    $FactureCheckBox.Checked = $true
    
    $FactureCode1ComboBox.SelectedIndex = -1
    $Prix1Box.Text = "0.00"
    $FactureDescription1Box.Focus()
    $FactureDescription1Box.text = ""
        
    $FactureCode2ComboBox.SelectedIndex = -1
    $Prix2Box.Text = "0.00"
    $FactureDescription2Box.Focus()
    $FactureDescription2Box.text = ""
        
    $FactureCode3ComboBox.SelectedIndex = -1
    $Prix3Box.Text = "0.00"
    $FactureDescription3Box.Focus()
    $FactureDescription3Box.text = ""
        
    $FactureCode4ComboBox.SelectedIndex = -1
    $Prix4Box.Text = "0.00"
    $FactureDescription4Box.Focus()
    $FactureDescription4Box.text = ""
        
    $FactureCode5ComboBox.SelectedIndex = -1
    $Prix5Box.Text = "0.00"
    $FactureDescription5Box.Focus()
    $FactureDescription5Box.text = ""
    $PrixTotalBox.ForeColor = 'Black'

    $RabaisPourcentageBox.Value = 0;
    $Rabais1Box.Value = 0
    $Rabais2Box.Value = 0
    $Rabais3Box.Value = 0
    $Rabais4Box.Value = 0
    $Rabais5Box.Value = 0

    $FactureCheckBox.Checked = $false


    $NouveauClientCheckBox.focus()
    $NouveauClientCheckBox.Checked = $true
    
    $MarqueBox.Focus()
    $MarqueBox.Text = ""
    $IncidentBox.Focus()
    $IncidentBox.Text = ""
    $NSBox.Focus()
    $NSBox.Text = ""
    $ModeleBox.Focus()
    $ModeleBox.Text = ""
    $MDPBox.Focus()
    $MDPBox.Text = ""
    $LangueBox.SelectedItem = "FR"
    $AutresInfosBox.Focus()
    $AutresInfosBox.Text = ""
    $InfoImportanteOUICheckBox.Checked = $false
    $InfoImportanteNONCheckBox.Checked = $false
    $CordonAlimentationOUICheckBox.Checked = $false
    $CordonAlimentationNONCheckBox.Checked = $false
    $PrenomBox.Focus()
    
})
$CancelButton.BackColor = 'White'
$objForm.Controls.Add($CancelButton)

#OK Bouton
$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Size(250,770)
$OKButton.Size = New-Object System.Drawing.Size(200,90)
$OKButton.TabIndex = 98
$OKButton.Text = "Send"
$OKButton.Add_Click({
    $NomBox.BackColor = [System.Drawing.Color]::LightCyan
    $PrenomBox.BackColor = [System.Drawing.Color]::LightCyan
    $Phone1Box.BackColor = [System.Drawing.Color]::LightCyan
    $YesNoGroupBox.BackColor = [System.Drawing.Color]::LightSlateGray
    $IncidentBox.BackColor = [System.Drawing.Color]::LightCyan
    $MarqueBox.BackColor = [System.Drawing.Color]::LightCyan
    $PrixTotalBox.ForeColor = 'Black'
    $AllUsers = Import-Csv -Encoding Default $csv
    $CodesCSV = Import-Csv -Encoding Default $facturationCSV
    $Incidents = Import-Csv -Delimiter ';' -Encoding Default $IncidentsCSV
    $ListeFacture = Import-Csv -Delimiter ';' -Encoding Default $factures
    $taxes = Import-Csv $taxesCSV
    #Si nouveau client
    $ClientValide = $false
    $NouveauUser = $null
    $DeuxiemePartieValide = $false
    $IDduClientChoisi = "N/A"
    $messageSEND = ""
    if($NouveauClientCheckBox.Checked)
    {
        if($PrenomBox.text -ne ""  -and $PrenomBox.text -notlike "* *" -and $PrenomBox.ForeColor -ne 'DarkGray' -and $NomBox.ForeColor -ne 'DarkGray' -and $NomBox.Text -ne "" -and $NomBox.text -notlike "* *" -and $Phone1Box.ForeColor -ne 'DarkGray' -and  $Phone1Box.Text -ne "")
        {
            $ClientValide = $true
            $grosID = 0
            $AllUsers | ForEach-Object {
                if($_.Prenom -eq ($PrenomBox.Text) -and $_.Nom -eq ($NomBox.Text))
                {
                    $ClientValide = $false
                    $messageSEND += "Utilisateur avec le même nom déjà existant
                    
"
                }
                if(([int]($_.ID)) -gt $grosID)
                {
                    $grosID = ([int]($_.ID))
                }
            }
            $newID = ""+($grosID + 1)
            Write-Host $newID
            
            $tempTel2 = "N/A"
            $tempRue = "N/A"
            $tempCodePostal = "N/A"
            $tempCourriel = "N/A"
            $tempVille = "N/A"
            
            if($VilleComboBox.ForeColor -ne 'DarkGray')
            {
                $tempVille = $VilleComboBox.Text
            }
            if($CourrielBox.ForeColor -ne 'DarkGray' -and $CourrielBox.Text -ne "")
            {
                $tempCourriel = $CourrielBox.Text
            }
            if($CPBoc.ForeColor -ne 'DarkGray' -and $CPBoc.Text -ne "")
            {
                $tempCodePostal = $CPBoc.Text
            }
            if($RueBox.ForeColor -ne 'DarkGray' -and $RueBox.Text -ne "")
            {
                $tempRue = $RueBox.Text
            }
            if($Phone2Box.ForeColor -ne 'DarkGray' -and $Phone2Box.Text -ne "")
            {
                $tempTel2 = $Phone2Box.Text
            }
            $tempDateTime = (((get-date).day.toString()) + "/" + ((get-date).month.toString()) + "/" + ((get-date).year.toString()) + "  " + (get-date).ToString().split(" ")[1])
            $NouveauUser = "{0},{1},{2},{3},{4},{5},{6},{7},{8},{9},{10},{11}" -f $newID,$NomBox.Text,$PrenomBox.Text,$tempCourriel,$Phone1Box.Text,$tempTel2,$tempRue,$tempVille,$ProvinceBox.Text,$PaysBox.Text,$tempCodePostal,$tempDateTime            
            
            $IDduClientChoisi = $newID
            
        }
        else
        {
            Write-host "OOPS-Missing Info new"
            if($PrenomBox.Text -eq "" -or $PrenomBox.ForeColor -eq 'DarkGray' -or $PrenomBox.Text -like '* *')
            {
                $PrenomBox.BackColor = 'DarkRed'
            }
            if($NomBox.Text -eq "" -or $NomBox.ForeColor -eq 'DarkGray' -or $NomBox.Text -like '* *')
            {
                $NomBox.BackColor = 'DarkRed'
            }
            if($Phone1Box.Text -eq "" -or $Phone1Box.ForeColor -eq 'DarkGray')
            {
                $Phone1Box.BackColor = 'DarkRed'
            }
            $messageSEND += "Information manquantes"
        }
    }
    #Si user existant (Mise a jour information client)
    else
    {
        if($PrenomBox.text -ne "" -and $PrenomBox.text -notlike "* *" -and $PrenomBox.ForeColor -ne 'DarkGray' -and $NomBox.ForeColor -ne 'DarkGray' -and $NomBox.Text -ne "" -and $NomBox.text -notlike "* *"-and $Phone1Box.ForeColor -ne 'DarkGray' -and  $Phone1Box.Text -ne "")
        {
            #Récupérer le user de la base de données et le mettre a jour
            $selectedUser = $AllUsers | Where-Object {($_.Prenom -eq (($ListeClientComboBox.SelectedItem).split(''))[0]) -and ($_.Nom -eq (($ListeClientComboBox.SelectedItem).split(''))[1])}
            $selecteduser.Prenom = $PrenomBox.Text
            $selecteduser.Nom = $NomBox.Text
            
            if($VilleComboBox.ForeColor -eq 'DarkGray' -or $VilleComboBox.Text -eq "Ville")
            {
                $selecteduser.Ville = "N/A"
            }
            else{
                $selecteduser.Ville = $VilleComboBox.Text
            }
            if($CourrielBox.ForeColor -eq 'DarkGray' -or $CourrielBox.Text -eq "")
            {
                $selecteduser.Email = "N/A"
            }
            else
            {
                $selecteduser.Email = $CourrielBox.Text
            }
            $selecteduser.Province = $ProvinceBox.Text
            if($CPBoc.ForeColor -eq 'DarkGray' -or $CPBoc.Text -eq "")
            {
                $selecteduser.CodePostal = "N/A"
            }
            else
            {
                $selecteduser.CodePostal = $CPBoc.Text
            }
            $selecteduser.Pays = $PaysBox.Text
            if($RueBox.ForeColor -eq 'DarkGray' -or $RueBox.Text -eq "")
            {
                $selecteduser.Rue = "N/A"
            }
            else
            {
                $selecteduser.Rue = $RueBox.Text
            }
            $selecteduser.Tel1 = $Phone1Box.Text
            if($Phone2Box.ForeColor -eq 'DarkGray' -or $Phone2Box.Text -eq "")
            {
                $selecteduser.Tel2 = "N/A"
            }
            else
            {
                $selecteduser.Tel2 = $Phone2Box.Text
            }
            $AllUsers | Export-Csv $csv -Encoding Default
            
            $ClientValide = $true
            $IDduClientChoisi = $selecteduser.ID

            $messageSEND += "Données utilisateurs mis-à-jour
            
"
        }
        else
        {
            Write-host "OOPS-Missing Info"
            if($PrenomBox.Text -eq "" -or $PrenomBox.text -like '* *' -or $PrenomBox.ForeColor -eq 'DarkGray')
            {
                $PrenomBox.BackColor = 'DarkRed'
            }
            if($NomBox.Text -eq "" -or $NomBox.text -like '* *' -or $NomBox.ForeColor -eq 'DarkGray')
            {
                $NomBox.BackColor = 'DarkRed'
            }
            if($Phone1Box.Text -eq "" -or $Phone1Box.ForeColor -eq 'DarkGray')
            {
                $Phone1Box.BackColor = 'DarkRed'
            }
            $messageSEND += "Information manquantes

"
        }
    }
    #pour le deuxieme groupBox
    
    #Si on fait une facture
    if($FactureCheckBox.Checked)
    {
        if($ClientValide -eq $true -and $FactureDescription1Box.Text -ne "Description" -and $FactureDescription1Box.Text -ne "")
        {
            if($NouveauClientCheckBox.Checked -eq $true)
            {
                $NouveauUser | Add-Content -path $csv -Encoding Default
                $messageSEND += "Utilisateur Ajouté à la base de données

"
            }
            Write-host "OK"
            $grosID = 0
            $ListeFacture | ForEach-Object {
                if(([int]($_.ID)) -gt $grosID)
                {
                    $grosID = ([int]($_.ID))
                }
            }
            $newID = ""+($grosID + 1)
            Write-Host $newID
            
            
            $tempSKU1 = "N/A"
            $tempSKU2 = "N/A"
            $tempSKU3 = "N/A"
            $tempSKU4 = "N/A"
            $tempSKU5 = "N/A"
            $tempDesc1 = "N/A"
            $tempDesc2 = "N/A"
            $tempDesc3 = "N/A"
            $tempDesc4 = "N/A"
            $tempDesc5 = "N/A"
            $tempPrix1 = "N/A"
            $tempPrix2 = "N/A"
            $tempPrix3 = "N/A"
            $tempPrix4 = "N/A"
            $tempPrix5 = "N/A"
            $tempTPS = "N/A"
            $tempTVQ = "N/A"
            
                       
            if($FactureCode1ComboBox.SelectedIndex -ne -1)
            {
                $tempSKU1 = $FactureCode1ComboBox.SelectedItem
            }
            if($FactureCode2ComboBox.SelectedIndex -ne -1)
            {
                $tempSKU2 = $FactureCode2ComboBox.SelectedItem
            }
            if($FactureCode3ComboBox.SelectedIndex -ne -1)
            {
                $tempSKU3 = $FactureCode3ComboBox.SelectedItem
            }
            if($FactureCode4ComboBox.SelectedIndex -ne -1)
            {
                $tempSKU4 = $FactureCode4ComboBox.SelectedItem
            }
            if($FactureCode5ComboBox.SelectedIndex -ne -1)
            {
                $tempSKU5 = $FactureCode5ComboBox.SelectedItem
            }
            if($FactureDescription1Box.ForeColor -ne 'DarkGray' -and $FactureDescription1Box.Text -ne "")
            {
                $tempDesc1 = $FactureDescription1Box.Text
                if($Rabais1Box.Value -ne 0){
                $tempRabais = $Rabais1Box.Value
                $tempDesc1 += " (Rabais de $tempRabais%)"
                }
            }
            if($FactureDescription2Box.ForeColor -ne 'DarkGray' -and $FactureDescription2Box.Text -ne "")
            {
                $tempDesc2 = $FactureDescription2Box.Text
                if($Rabais2Box.Value -ne 0){
                $tempRabais = $Rabais2Box.Value
                $tempDesc2 += " (Rabais de $tempRabais%)"
                }
            }
            if($FactureDescription3Box.ForeColor -ne 'DarkGray' -and $FactureDescription3Box.Text -ne "")
            {
                $tempDesc3 = $FactureDescription3Box.Text
                if($Rabais3Box.Value -ne 0){
                $tempRabais = $Rabais3Box.Value
                $tempDesc3 += " (Rabais de $tempRabais%)"
                }
            }
            if($FactureDescription4Box.ForeColor -ne 'DarkGray' -and $FactureDescription4Box.Text -ne "")
            {
                $tempDesc4 = $FactureDescription4Box.Text
                if($Rabais4Box.Value -ne 0){
                $tempRabais = $Rabais4Box.Value
                $tempDesc4 += " (Rabais de $tempRabais%)"
                }
            }
            if($FactureDescription5Box.ForeColor -ne 'DarkGray' -and $FactureDescription5Box.Text -ne "")
            {
                $tempDesc5 = ""+$FactureDescription5Box.Text
                if($Rabais5Box.Value -ne 0){
                $tempRabais = $Rabais5Box.Value
                $tempDesc5 += " (Rabais de $tempRabais%)"
                }
            }
            if($FactureDescription1Box.Text -ne "Description" -and $FactureCode1ComboBox -ne "")
            {
                $tempPrix1 = $Prix1Box.Text
            }
            if($FactureDescription2Box.Text -ne "Description" -and $FactureCode2ComboBox -ne "")
            {
                $tempPrix2 = $Prix2Box.Text
            }
            if($FactureDescription3Box.Text -ne "Description" -and $FactureCode3ComboBox -ne "")
            {
                $tempPrix3 = $Prix3Box.Text
            }
            if($FactureDescription4Box.Text -ne "Description" -and $FactureCode4ComboBox -ne "")
            {
                $tempPrix4 = $Prix4Box.Text
            }
            if($FactureDescription5Box.Text -ne "Description" -and $FactureCode5ComboBox -ne "")
            {
                $tempPrix5 = $Prix5Box.Text
            }
            if($TPSCashTotalBox.Value -ne 0)
            {
                $tempTPS = $TPSCashTotalBox.Value
            }
            if($TVQCashTotalBox.Value -ne 0)
            {
                $tempTVQ = $TVQCashTotalBox.Value
            }
            
            $tempSousTotal = $PrixTotalBox.Value - ($TVQCashTotalBox.Value + $TPSCashTotalBox.Value)
            $tempDateTime = (((get-date).day.toString()) + "/" + ((get-date).month.toString()) + "/" + ((get-date).year.toString()) + "  " + (get-date).ToString().split(" ")[1])
            
            $NouvelleFacture = "{0};{1};{2};{3};{4};{5};{6};{7};{8};{9};{10};{11};{12};{13};{14};{15};{16};{17};{18};{19};{20};{21}" -f $newID,$IDduClientChoisi,$tempSKU1,$tempDesc1,$tempPrix1,$tempSKU2,$tempDesc2,$tempPrix2,$tempSKU3,$tempDesc3,$tempPrix3,$tempSKU4,$tempDesc4,$tempPrix4,$tempSKU5,$tempDesc5,$tempPrix5, $PrixTotalBox.Value,$tempSousTotal,$tempTPS,$tempTVQ,$tempDateTime
            $NouvelleFacture | Add-Content -path $factures -Encoding Default
            $AllUsers = Import-Csv -Encoding Default $csv
            $userLIVE = $AllUsers | Where-Object {($_.ID -eq $IDduClientChoisi)}

            #Création du fichier de facture
            $tempnomduFichier = $destinationFichiers + ""+$IDduClientChoisi + "_" +$newID + "_" + (Get-Date).Day +"-" + (Get-Date).Month + "-" + (Get-Date).Year + "_Facture.xlsx"
            Copy-Item -Path $fichierFacture -Destination $tempnomduFichier

            $xl = New-Object -COM "Excel.Application"
            $xl.Visible = $true
            $wb = $xl.Workbooks.Open($tempnomduFichier)
            $ws = $wb.Sheets.Item(1)
            $selection = $ws.UsedRange

            if($tempPrix1 -eq "N/A"){
                $tempPrix1 = ""
            }
            if($tempPrix2 -eq "N/A"){
                $tempPrix2 = ""
            }
            if($tempPrix3 -eq "N/A"){
                $tempPrix3 = ""
            }
            if($tempPrix4 -eq "N/A"){
                $tempPrix4 = ""
            }
            if($tempPrix5 -eq "N/A"){
                $tempPrix5 = ""
            }
            if($tempSKU1 -eq "N/A"){
                $tempSKU1 = ""
            }
            if($tempSKU2 -eq "N/A"){
                $tempSKU2 = ""
            }
            if($tempSKU3 -eq "N/A"){
                $tempSKU3 = ""
            }
            if($tempSKU4 -eq "N/A"){
                $tempSKU4 = ""
            }
            if($tempSKU5 -eq "N/A"){
                $tempSKU5 = ""
            }
            if($tempDesc1 -eq "N/A"){
                $tempDesc1 = ""
            }
            if($tempDesc2 -eq "N/A"){
                $tempDesc2 = ""
            }
            if($tempDesc3 -eq "N/A"){
                $tempDesc3 = ""
            }
            if($tempDesc4 -eq "N/A"){
                $tempDesc4 = ""
            }
            if($tempDesc5 -eq "N/A"){
                $tempDesc5 = ""
            }


            $tempNom = $userLIVE.Prenom + " " + $userLIVE.Nom
            $temptel1 = $userLIVE.Tel1
            $temptel2 = $userLIVE.Tel2
            $tempRue = $userLIVE.Rue
            $tempVille = $userLIVE.Ville + ", " + $userLIVE.CodePostal
            
            $month = ((Get-Date).Month).ToString()
            $day = ((Get-Date).Day).ToString()
            $year = ((Get-Date).Year).ToString()
            $tempdate = "$day-$month-$year"

            #Remplacer les termes du fichier template par les bonnes informations
            $selection.Replace("Client_Name", "$tempNom")
            $selection.Replace("Client_Rue", "$tempRue")
            $selection.Replace("Client_CP", "$tempVille")
            $selection.Replace("Client_Tel1", "$temptel1")
            $selection.Replace("Client_Tel2", "$temptel2")
            
            $selection.Replace("DATE_DATE", "$tempdate")
            $selection.Replace("Num_Fact", "$newID")
            $selection.Replace("Client_ID", "$IDduClientChoisi")

            $selection.Replace("SKU1", "$tempSKU1")
            $selection.Replace("SKU2", "$tempSKU2")
            $selection.Replace("SKU3", "$tempSKU3")
            $selection.Replace("SKU4", "$tempSKU4")
            $selection.Replace("SKU5", "$tempSKU5")
            $selection.Replace("Desc1", "$tempDesc1")
            $selection.Replace("Desc2", "$tempDesc2")
            $selection.Replace("Desc3", "$tempDesc3")
            $selection.Replace("Desc4", "$tempDesc4")
            $selection.Replace("Desc5", "$tempDesc5")
            $selection.Replace("Prix_1", "$tempPrix1")
            $selection.Replace("Prix_2", "$tempPrix2")
            $selection.Replace("Prix_3", "$tempPrix3")
            $selection.Replace("Prix_4", "$tempPrix4")
            $selection.Replace("Prix_5", "$tempPrix5")

            $tempTPS = $TPSCashTotalBox.Value
            $tempTVQ = $TVQCashTotalBox.Value

            $selection.Replace("Prix_TPS", "$tempTPS")
            $selection.Replace("Prix_TVQ", "$tempTVQ")


            $temptaxtotal = [int]($tempTPS) + [int]($tempTVQ)
            $temptotal = $PrixTotalBox.value+""

            $selection.Replace("Prix_Total", "$temptotal")

            #Enregirster le Fichier
            $xl.ActiveWorkBook.Save()

            ###################################
            ##                               ##
            ##   IMPRESSION DU FICHIER ICI   ##
            ##                               ##
            ###################################
             
            #$wb.PrintOut()
            #$wb.PrintOut()



            $messageSEND += "Facture ajoutée à la base de données"
            $ClientExistantCheckBox.Checked = $true
            $nomClientTemp = ($userLIVE.Prenom)+" " +($userLIVE.Nom)
            $ListeClientComboBox.SelectedItem = $nomClientTemp
        }
        else
        {
            $PrixTotalBox.ForeColor = 'Red'
            $messageSEND += "Facture vide: Aucune action"
        }
        
    }
    #Si on fait un probleme
    else
    {
        $checkBoxUsed = $true
        Write-Host $ClientValide
        if($InfoImportanteNONCheckBox.Checked -ne $true -and $InfoImportanteOUICheckBox.Checked -ne $true){
            $checkBoxUsed = $false}
        if($CordonAlimentationNONCheckBox.Checked -ne $true -and $CordonAlimentationOUICheckBox.Checked -ne $true){
            $checkBoxUsed = $false}
        if($IncidentBox.text -ne "" -and $IncidentBox.ForeColor -ne 'DarkGray' -and $MarqueBox.ForeColor -ne 'DarkGray' -and $MarqueBox.Text -ne "" -and $checkBoxUsed -ne $false -and $ClientValide -eq $true)
        {
            if($NouveauClientCheckBox.Checked -eq $true)
            {
                $NouveauUser | Add-Content -path $csv -Encoding Default
                $messageSEND += "Utilisateur Ajouté à la base de données
                
"
            }
            Write-host "OK"
            $grosID = 0
            $Incidents | ForEach-Object {
                if(([int]($_.ID)) -gt $grosID)
                {
                    $grosID = ([int]($_.ID))
                }
            }
            $newID = ""+($grosID + 1)
            Write-Host $newID
            
            
            $tempModele = "N/A"
            $tempPassword = "N/A"
            $tempNoSerie = "N/A"
            $tempLangue = "N/A"
            $tempautreInfos = "N/A"
            $tempCordon = "NO"
            $tempDATA = "NO"
            
            if($ModeleBox.ForeColor -ne 'DarkGray' -and $ModeleBox.Text -ne "")
            {
                $tempModele = ""+$ModeleBox.Text
            }
            if($MDPBox.ForeColor -ne 'DarkGray' -and $MDPBox.Text -ne "")
            {
                $tempPassword = $MDPBox.Text
            }
            if($NSBox.ForeColor -ne 'DarkGray' -and $NSBox.Text -ne "")
            {
                $tempNoSerie = $NSBox.Text
            }
            if($LangueBox.ForeColor -ne 'DarkGray' -and $LangueBox.Text -ne "")
            {
                $tempLangue = $LangueBox.Text
            }
            if($AutresInfosBox.ForeColor -ne 'DarkGray' -and $AutresInfosBox.Text -ne "")
            {
                $tempautreInfos = $AutresInfosBox.Text
            }
            if($CordonAlimentationOUICheckBox.Checked){
                $tempCordon = "YES"}
            if($InfoImportanteOUICheckBox.Checked){
                $tempDATA = "YES"}

            $tempDateTime = (((get-date).day.toString()) + "/" + ((get-date).month.toString()) + "/" + ((get-date).year.toString()) + "  " + (get-date).ToString().split(" ")[1])
            $NouveauIncident = "{0};{1};{2};{3};{4};{5};{6};{7};{8};{9};{10};{11}" -f $newID,$IDduClientChoisi,$MarqueBox.Text,$tempModele,$tempNoSerie,$tempPassword,$tempLangue,$tempDATA,$tempCordon,$IncidentBox.Text,$tempautreInfos,$tempDateTime
            $NouveauIncident | Add-Content -path $IncidentsCSV -Encoding Default
            
            Write-Host $IDduClientChoisi
            Write-Host $AllUsers
            $AllUsers = Import-Csv -Encoding Default $csv
            $userLIVE = $AllUsers | Where-Object {($_.ID -eq $IDduClientChoisi)}
            
            Write-Host $userLIVE
            #Création du fichier de problemes
            $tempnomduFichier = $destinationFichiers + ""+$IDduClientChoisi + "_" +$newID + "_" + (Get-Date).Day +"-" + (Get-Date).Month + "-" + (Get-Date).Year + "_Incident.xlsx"
            Copy-Item -Path $fichierIncident -Destination $tempnomduFichier

            $xl = New-Object -COM "Excel.Application"
            $xl.Visible = $true
            $wb = $xl.Workbooks.Open($tempnomduFichier)
            $ws = $wb.Sheets.Item(1)
            $selection = $ws.UsedRange
            $tempNom = $userLIVE.Prenom + " " + $userLIVE.Nom
            $temptel1 = $userLIVE.Tel1
            $temptel2 = $userLIVE.Tel2
            $tempRue = $userLIVE.Rue
            $tempVille = $userLIVE.Ville
            $tempEmail = $userLIVE.Email
            $tempCP = $userLIVE.CodePostal
            
            #remplacer les code du template par les bonnes information
            $selection.Replace("Nom_Client", "$tempNom")
            $selection.Replace("Tel_Client", "$temptel1")
            $selection.Replace("Cel_Client", "$temptel2")
            $selection.Replace("Rue_Client", "$tempRue")
            $selection.Replace("Ville_Client", "$tempVille")
            $selection.Replace("CP_Client", "$tempCP")
            
            $selection.Replace("Marque_PC", (""+$MarqueBox.Text))
            $selection.Replace("Modele_PC", "$tempModele")
            $selection.Replace("NS_PC", "$tempNoSerie")
            $selection.Replace("Langue_PC", "$tempLangue")
            $selection.Replace("Pass_PC", "$tempPassword")
            $selection.Replace("Detail_PC", "$tempautreInfos")
            $texttemp = ($IncidentBox.Text)
            $selection.Replace("Description1_PC", (""+$texttemp))

            if($CordonAlimentationOUICheckBox.Checked)
            {
                $selection.Replace("OUI_Cordon", "X")
                $selection.Replace("NON_Cordon", "")
            }
            else
            {
                $selection.Replace("OUI_Cordon", "")
                $selection.Replace("NON_Cordon", "X")
            }
            if($InfoImportanteOUICheckBox.Checked)
            {
                $selection.Replace("OUI_DATA", "X")
                $selection.Replace("NON_DATA", "")
            }
            else
            {
                $selection.Replace("OUI_DATA", "")
                $selection.Replace("NON_DATA", "X")
            }
            $selection.Replace("Courriel_Client", "$tempEmail")
            $xl.ActiveWorkBook.Save()

            ###################################
            ##                               ##
            ##   IMPRESSION DU FICHIER ICI   ##
            ##                               ##
            ###################################
             
            #$wb.PrintOut()
            #$wb.PrintOut()

            $messageSEND += "Incident ajouté à la base de données"
            $FactureCheckBox.Checked = $true
            $ClientExistantCheckBox.Checked = $true
            $nomClientTemp = ($userLIVE.Prenom)+" " +($userLIVE.Nom)
            $ListeClientComboBox.SelectedItem = $nomClientTemp
        }
        else
        {
            Write-host "OOPS"
            if($IncidentBox.Text -eq "" -or $IncidentBox.ForeColor -eq 'DarkGray')
            {
                $IncidentBox.BackColor = 'DarkRed'
            }
            if($MarqueBox.Text -eq "" -or $MarqueBox.ForeColor -eq 'DarkGray')
            {
                $MarqueBox.BackColor = 'DarkRed'
            }
            if($checkBoxUsed -eq $false)
            {
                $YesNoGroupBox.BackColor = 'DarkRed'
            }
            ($ClientValide -eq $true)
            {
                $messageSEND += "Incident incomplet: Aucune action"
            }
        }
    }
$wshell = New-Object -ComObject Wscript.Shell
$wshell.Popup("$messageSEND",1,"Done",0)
})
$OKButton.BackColor = 'White'
$objForm.Controls.Add($OKButton)



$objForm.Add_Shown({$objForm.Activate(); $GroupBoxClient.focus()})
[void] $objForm.ShowDialog()
