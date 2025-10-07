# Documentation complète de la bibliothèque UI Akiri

## Table des matières
1. [Introduction](#introduction)
2. [Installation](#installation)
3. [Initialisation](#initialisation)
4. [Structure de base](#structure-de-base)
5. [Composants](#composants)
6. [Utilitaires](#utilitaires)
7. [Thèmes](#thèmes)
8. [Exemples](#exemples)

---

## Introduction

Akiri UI Library est une bibliothèque d'interface graphique complète pour Roblox, utilisant le système Drawing API. Elle offre une interface personnalisable avec support de thèmes, animations et divers composants interactifs.

### Caractéristiques principales
- Interface moderne avec support des thèmes
- Système de dessin optimisé (Drawing API)
- Gestion des configurations (sauvegarde/chargement)
- Support des keybinds personnalisables
- Watermark et liste de keybinds
- Preview ESP intégré
- Notifications système
- Multi-tabs avec sections

---

## Installation

```lua
local Library = loadstring(game:HttpGet("https://akiri.best/assets/files/gayasf.ui2?key=VOTRE_CLE"))()
```

Ou en local :
```lua
local Library = loadstring(readfile("chemin/vers/library.lua"))()
```

---

## Initialisation

### Créer un Loader (écran de chargement)

```lua
local Loader = Library.CreateLoader("Nom du Script", Vector2.new(400, 200))
```

**Méthodes du Loader :**
- `Loader.SetText(valeur, texte)` - Met à jour la progression
  - `valeur` : Nombre entre 0 et Loader.Max
  - `texte` : Texte descriptif à afficher

**Exemple :**
```lua
local Loader = Library.CreateLoader("Mon Script", Vector2.new(400, 200))
Loader.SetText(0, "Initialisation...")
task.wait(1)
Loader.SetText(1, "Chargement des assets...")
task.wait(1)
Loader.SetText(2, "Terminé!")
```

### Créer une fenêtre principale

```lua
local Window = Library.Window("Titre de la fenêtre", Vector2.new(650, 600))
```

---

## Structure de base

```lua
-- 1. Créer la fenêtre
local Window = Library.Window("Mon Script", Vector2.new(650, 600))

-- 2. Créer un onglet
local MainTab = Window:Tab("Principal")

-- 3. Créer des sections
local CombatSection = MainTab:Section("Combat", "Left")
local VisualsSection = MainTab:Section("Visuels", "Right")

-- 4. Ajouter des composants
local Toggle = CombatSection:Toggle({
    Title = "Mon Toggle",
    Default = false,
    Callback = function(state)
        print("Toggle:", state)
    end
})
```

---

## Composants

### 1. Toggle (Interrupteur)

Composant on/off de base.

```lua
local Toggle = Section:Toggle({
    Title = "Activer Feature",
    Default = false,
    State = false,
    Flag = "MonToggle",
    Type = "Normal", -- ou "Dangerous" (couleur jaune)
    Callback = function(state)
        print("Toggle état:", state)
    end
})
```

**Méthodes :**
- `Toggle:Set(state)` - Définir l'état manuellement

**Flags :**
```lua
-- Accéder à la valeur
local valeur = Library.Flags["MonToggle"]
```

---

### 2. Slider (Curseur)

Sélectionner une valeur dans une plage.

```lua
local Slider = Section:Slider({
    Title = "Vitesse",
    Min = 0,
    Max = 100,
    Default = 50,
    Decimals = 1,
    Symbol = "%",
    Flag = "MonSlider",
    Callback = function(value)
        print("Valeur:", value)
    end
})
```

**Paramètres :**
- `Min` : Valeur minimale
- `Max` : Valeur maximale
- `Default` : Valeur par défaut
- `Decimals` : Précision (1 = entiers, 10 = 1 décimale, etc.)
- `Symbol` : Symbole affiché après la valeur

**Méthodes :**
- `Slider:Set(value)` - Définir la valeur
- `Slider:SetMax(max)` - Changer le maximum
- `Slider:SetMin(min)` - Changer le minimum
- `Slider:SetText(text)` - Changer le texte affiché

---

### 3. Button (Bouton)

Bouton cliquable simple.

```lua
local Button = Section:Button({
    Title = "Cliquez-moi",
    Callback = function()
        print("Bouton cliqué!")
    end
})
```

**Méthodes :**
- `Button:EmitEffect()` - Déclencher l'effet visuel

---

### 4. Dropdown (Menu déroulant)

Sélectionner une option parmi plusieurs.

```lua
local Dropdown = Section:Dropdown({
    Title = "Mode",
    List = {"Option 1", "Option 2", "Option 3"},
    Default = "Option 1",
    Flag = "MonDropdown",
    Callback = function(selected)
        print("Sélectionné:", selected)
    end
})
```

**Méthodes :**
- `Dropdown:Set(option)` - Sélectionner une option
- `Dropdown:ShowList(state)` - Afficher/masquer la liste

---

### 5. Colorpicker (Sélecteur de couleur)

Choisir une couleur avec roue HSV.

```lua
local Colorpicker = Section:Colorpicker({
    Title = "Couleur ESP",
    Color = Color3.fromRGB(255, 0, 0),
    Flag = "MaCouleur",
    Callback = function(color)
        print("Couleur:", color)
    end
})
```

**Méthodes :**
- `Colorpicker:SetHue({Value = valeur})` - Définir la teinte (0-1)
- `Colorpicker:SetSaturationX({Value = valeur})` - Définir la saturation X
- `Colorpicker:SetSaturationY({Value = valeur})` - Définir la saturation Y
- `Colorpicker:Drop(state)` - Ouvrir/fermer le picker

**Options :**
- Support du mode Rainbow
- Affichage Hex et RGB
- Curseur de teinte

**Exemple avec Rainbow :**
```lua
-- Le mode Rainbow est automatiquement géré via l'interface
-- Il met à jour continuellement la couleur
```

---

### 6. Keybind (Raccourci clavier)

Assigner une touche à une action.

```lua
local Keybind = Section:Keybind({
    Title = "Raccourci",
    Key = Enum.KeyCode.E,
    StateType = "Toggle", -- "Hold", "Toggle", ou "Always"
    Flag = "MonKeybind",
    Callback = function(state, key)
        print("Keybind état:", state, "Touche:", key)
    end
})
```

**Types d'état :**
- `Hold` : Actif uniquement quand la touche est pressée
- `Toggle` : Bascule on/off à chaque pression
- `Always` : Toujours actif

**Méthodes :**
- `Keybind:SetStateType(type)` - Changer le type d'état
- `Keybind:Drop(state)` - Afficher/masquer le menu de sélection

**Exemple avec toggle sur un Toggle :**
```lua
local Toggle = Section:Toggle({
    Title = "Aimbot",
    Callback = function(state) end
})

local Keybind = Toggle:Keybind({
    Title = "Aimbot Key",
    Key = Enum.KeyCode.Q,
    StateType = "Toggle",
    Callback = function(state)
        Toggle:Set(state)
    end
})
```

---

### 7. TextBox (Champ de texte)

Saisir du texte.

```lua
local TextBox = Section:TextBox({
    Title = "Nom",
    Current = "",
    Flag = "MonTexte",
    Callback = function(text)
        print("Texte saisi:", text)
    end
})
```

**Méthodes :**
- `TextBox:Set()` - Définir le texte (à implémenter)

---

### 8. Label (Étiquette)

Afficher du texte simple.

```lua
local Label = Section:Label("Texte informatif")
```

**Méthodes :**
- `Label:Set(text)` - Changer le texte

---

### 9. Colorpicker sur Toggle

Ajouter un sélecteur de couleur à un toggle.

```lua
local Toggle = Section:Toggle({
    Title = "ESP Boxes",
    Callback = function(state) end
})

local Color = Toggle:Colorpicker({
    Color = Color3.fromRGB(255, 255, 255),
    Flag = "ESPBoxColor",
    Callback = function(color)
        print("Couleur ESP:", color)
    end
})
```

---

## Utilitaires

### Gestion des configurations

#### Sauvegarder une configuration

```lua
Utility.SaveConfig("nom_config")
```

Sauvegarde dans : `akiri/Configs/[PlaceId]/nom_config.json`

#### Charger une configuration

```lua
Utility.LoadConfig("nom_config")
```

#### Supprimer une configuration

```lua
Utility.DeleteConfig("nom_config")
```

**Exemple d'interface de configuration :**
```lua
local ConfigSection = Tab:Section("Configs", "Right")

local ConfigName = ""
ConfigSection:TextBox({
    Title = "Nom de la config",
    Callback = function(text)
        ConfigName = text
    end
})

ConfigSection:Button({
    Title = "Sauvegarder",
    Callback = function()
        if ConfigName ~= "" then
            Utility.SaveConfig(ConfigName)
        end
    end
})

ConfigSection:Button({
    Title = "Charger",
    Callback = function()
        if ConfigName ~= "" then
            Utility.LoadConfig(ConfigName)
        end
    end
})
```

---

### Watermark (Filigrane)

Afficher un filigrane avec informations.

```lua
local Watermark = Window.Watermark("Mon Script")
```

**Affichage automatique :**
- Nom du script
- Heure actuelle
- Date complète

**Propriétés :**
- `Watermark.Visible` - Afficher/masquer

```lua
Watermark.Visible = false -- Masquer
Watermark.Visible = true  -- Afficher
```

---

### Notifications

Afficher des notifications temporaires.

```lua
Window.SendNotification("Type", "Message", Durée)
```

**Types disponibles :**
- `"Normal"` - Notification standard (ligne bleue)
- `"Warning"` - Avertissement (ligne orange)
- `"Error"` - Erreur (ligne rouge)

**Exemple :**
```lua
Window.SendNotification("Normal", "Script chargé avec succès!", 3)
Window.SendNotification("Warning", "Fonctionnalité en beta", 5)
Window.SendNotification("Error", "Erreur de connexion", 4)
```

---

### Visibilité de la fenêtre

Basculer l'affichage de l'interface.

```lua
Library:ChangeVisible(state)
```

**Exemple avec keybind :**
```lua
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        Library.WindowVisible = not Library.WindowVisible
        Library:ChangeVisible(Library.WindowVisible)
    end
end)
```

---

### ESP Preview

Afficher un aperçu ESP dans l'interface.

```lua
local ESPPreview = Tab:AddESPPreview()
```

**Méthodes :**
- `ESPPreview:UpdateName(state, color)` - Afficher le nom
- `ESPPreview:UpdateBoundingBox(state, color)` - Afficher la box
- `ESPPreview:UpdateDistance(state, color)` - Afficher la distance
- `ESPPreview:UpdateWeapon(state, color)` - Afficher l'arme
- `ESPPreview:UpdateHealthBar(state, color, config)` - Afficher la barre de vie

**Exemple complet :**
```lua
local ESPPreview = VisualTab:AddESPPreview()

local NameToggle = Section:Toggle({
    Title = "Noms",
    Callback = function(state)
        ESPPreview:UpdateName(state, Color3.fromRGB(255, 255, 255))
    end
})

local BoxToggle = Section:Toggle({
    Title = "Boxes",
    Callback = function(state)
        ESPPreview:UpdateBoundingBox(state, Color3.fromRGB(255, 0, 0))
    end
})

local HealthToggle = Section:Toggle({
    Title = "Barre de vie",
    Callback = function(state)
        ESPPreview:UpdateHealthBar(state, Color3.fromRGB(0, 255, 0), {
            Health = 75,
            MaxHealth = 100
        })
    end
})
```

---

### Player List

Afficher une liste des joueurs.

```lua
local PlayerList = Tab:AddPlayerlist()
```

**Méthodes :**
- `PlayerList:AddPlayer(player)` - Ajouter un joueur
- `PlayerList:RemovePlayer(player)` - Retirer un joueur
- `PlayerList:RefreshList(count)` - Rafraîchir l'affichage

**Exemple :**
```lua
local PlayerList = Tab:AddPlayerlist()

-- Ajouter les joueurs actuels
for _, player in pairs(game.Players:GetPlayers()) do
    PlayerList:AddPlayer(player)
end

-- Gérer les nouveaux joueurs
game.Players.PlayerAdded:Connect(function(player)
    PlayerList:AddPlayer(player)
end)

-- Gérer les joueurs qui partent
game.Players.PlayerRemoving:Connect(function(player)
    PlayerList:RemovePlayer(player)
end)
```

---

## Thèmes

### Thèmes prédéfinis

La bibliothèque inclut plusieurs thèmes :

1. **Default** - Thème violet par défaut
2. **Neverlose** - Cyan/bleu foncé
3. **Fatality** - Rose/violet
4. **Aimware** - Rouge
5. **Onetap** - Or
6. **Vape** - Vert
7. **Gamesense** - Vert clair
8. **OldAbyss** - Violet clair

### Appliquer un thème

```lua
Library:UpdateTheme({
    Accent = Color3.fromRGB(255, 0, 0),
    Outline = Color3.fromRGB(0, 0, 5),
    Inline = Color3.fromRGB(60, 60, 60),
    LightContrast = Color3.fromRGB(35, 25, 70),
    DarkContrast = Color3.fromRGB(25, 20, 50),
    Text = Color3.fromRGB(200, 200, 255),
    TextInactive = Color3.fromRGB(175, 175, 175)
})
```

### Onglet Settings automatique

```lua
local Settings = Window:AddSettingsTab(function()
    -- Code à exécuter lors du Self Destruct
    print("Interface détruite")
end)
```

Cet onglet inclut automatiquement :
- Sélecteurs de couleur pour chaque élément du thème
- Dropdown de thèmes prédéfinis
- Toggle pour l'anime
- Sélection de l'anime
- Bouton Self Destruct

---

## Exemples

### Exemple 1 : Script simple avec aimbot

```lua
-- Initialisation
local Library = loadstring(game:HttpGet("URL"))()
local Loader = Library.CreateLoader("Mon Aimbot", Vector2.new(400, 200))

Loader.SetText(0, "Chargement...")
task.wait(1)
Loader.SetText(2, "Prêt!")

-- Création de la fenêtre
local Window = Library.Window("Mon Script", Vector2.new(650, 600))
local Watermark = Window.Watermark("Mon Script v1.0")

-- Onglet Combat
local Combat = Window:Tab("Combat")
local AimbotSection = Combat:Section("Aimbot", "Left")

-- Variables
local AimbotEnabled = false
local AimbotFOV = 100

-- Toggle Aimbot
local AimbotToggle = AimbotSection:Toggle({
    Title = "Activer Aimbot",
    Flag = "AimbotEnabled",
    Callback = function(state)
        AimbotEnabled = state
        print("Aimbot:", state)
    end
})

-- Keybind
local AimbotKey = AimbotToggle:Keybind({
    Title = "Touche Aimbot",
    Key = Enum.KeyCode.E,
    StateType = "Hold",
    Callback = function(state)
        AimbotToggle:Set(state)
    end
})

-- FOV Slider
local FOVSlider = AimbotSection:Slider({
    Title = "FOV",
    Min = 50,
    Max = 500,
    Default = 100,
    Symbol = "°",
    Flag = "AimbotFOV",
    Callback = function(value)
        AimbotFOV = value
    end
})

-- Onglet Settings
local Settings = Window:AddSettingsTab()

-- Toggle de visibilité
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        Library:ChangeVisible(not Library.WindowVisible)
    end
end)
```

---

### Exemple 2 : ESP complet

```lua
local Window = Library.Window("ESP Script", Vector2.new(650, 600))

-- Onglet Visuels
local Visuals = Window:Tab("Visuels")
local ESPSection = Visuals:Section("ESP", "Left")

-- Prévisualisation
local ESPPreview = Visuals:AddESPPreview()

-- Configuration ESP
local ESPConfig = {
    Enabled = false,
    Boxes = false,
    BoxColor = Color3.fromRGB(255, 0, 0),
    Names = false,
    NameColor = Color3.fromRGB(255, 255, 255),
    Distance = false,
    DistanceColor = Color3.fromRGB(255, 255, 255),
    HealthBar = false,
    HealthBarColor = Color3.fromRGB(0, 255, 0)
}

-- Toggle principal
ESPSection:Toggle({
    Title = "Activer ESP",
    Flag = "ESPEnabled",
    Callback = function(state)
        ESPConfig.Enabled = state
    end
})

-- Boxes
local BoxToggle = ESPSection:Toggle({
    Title = "Boxes",
    Flag = "ESPBoxes",
    Callback = function(state)
        ESPConfig.Boxes = state
        ESPPreview:UpdateBoundingBox(state, ESPConfig.BoxColor)
    end
})

local BoxColor = BoxToggle:Colorpicker({
    Color = Color3.fromRGB(255, 0, 0),
    Flag = "ESPBoxColor",
    Callback = function(color)
        ESPConfig.BoxColor = color
        ESPPreview:UpdateBoundingBox(ESPConfig.Boxes, color)
    end
})

-- Noms
local NameToggle = ESPSection:Toggle({
    Title = "Noms",
    Flag = "ESPNames",
    Callback = function(state)
        ESPConfig.Names = state
        ESPPreview:UpdateName(state, ESPConfig.NameColor)
    end
})

local NameColor = NameToggle:Colorpicker({
    Color = Color3.fromRGB(255, 255, 255),
    Flag = "ESPNameColor",
    Callback = function(color)
        ESPConfig.NameColor = color
        ESPPreview:UpdateName(ESPConfig.Names, color)
    end
})

-- Distance
local DistToggle = ESPSection:Toggle({
    Title = "Distance",
    Flag = "ESPDistance",
    Callback = function(state)
        ESPConfig.Distance = state
        ESPPreview:UpdateDistance(state, ESPConfig.DistanceColor)
    end
})

-- Barre de vie
local HealthToggle = ESPSection:Toggle({
    Title = "Barre de vie",
    Flag = "ESPHealth",
    Callback = function(state)
        ESPConfig.HealthBar = state
        ESPPreview:UpdateHealthBar(state, ESPConfig.HealthBarColor, {
            Health = 75,
            MaxHealth = 100
        })
    end
})
```

---

### Exemple 3 : Système de configuration complet

```lua
local Window = Library.Window("Script avec Configs", Vector2.new(650, 600))

-- Onglet Settings
local Settings = Window:Tab("Paramètres")
local ConfigSection = Settings:Section("Configurations", "Right")

-- Variable pour stocker le nom
local ConfigName = ""

-- TextBox pour le nom
ConfigSection:TextBox({
    Title = "Nom de la configuration",
    Current = "",
    Callback = function(text)
        ConfigName = text
    end
})

-- Bouton Sauvegarder
ConfigSection:Button({
    Title = "Sauvegarder",
    Callback = function()
        if ConfigName ~= "" then
            Utility.SaveConfig(ConfigName)
            Window.SendNotification("Normal", "Config sauvegardée: " .. ConfigName, 3)
        else
            Window.SendNotification("Error", "Entrez un nom de config", 3)
        end
    end
})

-- Bouton Charger
ConfigSection:Button({
    Title = "Charger",
    Callback = function()
        if ConfigName ~= "" then
            local success = pcall(function()
                Utility.LoadConfig(ConfigName)
            end)
            
            if success then
                Window.SendNotification("Normal", "Config chargée: " .. ConfigName, 3)
            else
                Window.SendNotification("Error", "Config introuvable", 3)
            end
        else
            Window.SendNotification("Error", "Entrez un nom de config", 3)
        end
    end
})

-- Bouton Supprimer
ConfigSection:Button({
    Title = "Supprimer",
    Callback = function()
        if ConfigName ~= "" then
            Utility.DeleteConfig(ConfigName)
            Window.SendNotification("Warning", "Config supprimée: " .. ConfigName, 3)
        else
            Window.SendNotification("Error", "Entrez un nom de config", 3)
        end
    end
})

-- Liste des configs (exemple)
ConfigSection:Label("Configs disponibles:")

-- Dropdown avec les configs existantes
local configs = {}
if isfolder("akiri/Configs/" .. game.PlaceId) then
    for _, file in pairs(listfiles("akiri/Configs/" .. game.PlaceId)) do
        local name = file:match("([^/]+)%.json$")
        if name then
            table.insert(configs, name)
        end
    end
end

if #configs > 0 then
    ConfigSection:Dropdown({
        Title = "Configs",
        List = configs,
        Default = configs[1],
        Callback = function(selected)
            ConfigName = selected
        end
    })
end
```

---

## Bonnes pratiques

### 1. Organisation du code

```lua
-- Séparez votre code en sections logiques
local Config = {
    Aimbot = {},
    ESP = {},
    Misc = {}
}

-- Utilisez des flags cohérents
local AimbotToggle = Section:Toggle({
    Title = "Aimbot",
    Flag = "Aimbot_Enabled" -- Préfixe par catégorie
})
```

### 2. Gestion des erreurs

```lua
-- Utilisez pcall pour les opérations sensibles
local success, error = pcall(function()
    Utility.LoadConfig("maconfig")
end)

if not success then
    Window.SendNotification("Error", "Erreur: " .. tostring(error), 5)
end
```

### 3. Performance

```lua
-- Évitez les boucles dans les callbacks
local MyToggle = Section:Toggle({
    Callback = function(state)
        -- BON
        Config.Enabled = state
        
        -- MAUVAIS
        -- while state do
        --     -- Code lourd
        -- end
    end
})

-- Utilisez RunService pour les boucles
game:GetService("RunService").Heartbeat:Connect(function()
    if Config.Enabled then
        -- Votre code ici
    end
end)
```

### 4. Cleanup

```lua
-- Nettoyez les ressources lors de la fermeture
local Settings = Window:AddSettingsTab(function()
    -- Déconnectez les connexions
    for _, conn in pairs(Connections) do
        conn:Disconnect()
    end
    
    -- Nettoyez les variables
    Config = nil
    
    print("Script déchargé proprement")
end)
```

---

## Dépannage

### Problème : L'interface ne s'affiche pas
- Vérifiez que vous avez bien appelé `Library.Window()`
- Assurez-vous que `Library.WindowVisible` est `true`
- Vérifiez les erreurs dans la console

### Problème : Les flags ne fonctionnent pas
- Assurez-vous d'utiliser des noms de flags uniques
- Accédez aux flags via `Library.Flags["NomFlag"]`
- Les flags sont automatiquement créés par les composants

### Problème : Les configurations ne se sauvegardent pas
- Vérifiez que le dossier existe : `akiri/Configs/[PlaceId]`
- Utilisez uniquement des caractères valides dans les noms de fichiers
- Vérifiez que vous avez les permissions d'écriture

### Problème : Les couleurs ne s'appliquent pas
- Pour les colorpickers, utilisez la callback pour appliquer les changements
- Les couleurs sont stockées en Color3
- Utilisez `Library.Flags` pour récupérer les valeurs

---

## API Reference rapide

### Library
- `Library.CreateLoader(titre, taille)` → Loader
- `Library.Window(titre, taille)` → Window
- `Library:ChangeVisible(state)`
- `Library:UpdateTheme(config)`
- `Library.SelfDestruct()`
- `Library.Flags` - Table des valeurs
- `Library.Items` - Table des composants

### Window
- `Window:Tab(titre)` → Tab
- `Window:AddSettingsTab(callback)` → Tab
- `Window.Watermark(titre)` → Watermark
- `Window.SendNotification(type, message, durée)`
- `Window.ChangeAnime(nom)`
- `Window.ToggleAnime(state)`

### Tab
- `Tab:Section(titre, côté)` → Section
- `Tab:AddPlayerlist()` → PlayerList
- `Tab:AddESPPreview()` → ESPPreview

### Section
- `Section:Toggle(options)` → Toggle
- `Section:Slider(options)` → Slider
- `Section:Button(options)` → Button
- `Section:Dropdown(options)` → Dropdown
- `Section:Colorpicker(options)` → Colorpicker
- `Section:Keybind(options)` → Keybind
- `Section:TextBox(options)` → TextBox
- `Section:Label(texte)` → Label

### Utility
- `Utility.SaveConfig(nom)`
- `Utility.LoadConfig(nom)`
- `Utility.DeleteConfig(nom)`

---

## Conclusion

Cette bibliothèque offre tous les outils nécessaires pour créer une interface complète et professionnelle. N'hésitez pas à personnaliser les thèmes et à combiner les composants pour créer l'interface parfaite pour votre script.

Pour plus d'aide, consultez les exemples fournis ou contactez le support.

---

**Version de la documentation :** 1.0  
**Dernière mise à jour :** 2024  
**Auteur :** Akiri UI Library
