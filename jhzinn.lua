--[[
    ═══════════════════════════════════════════════════════════════════════════
    Jhzinn SISTEMA DOORS v6.0  [BOOT BLINDADO]
    Hotel · Minas · Arquivos · Porta dos Fundos
    UI primeiro · AntiBan isolado · ESP · Notificações na direita
    ═══════════════════════════════════════════════════════════════════════════
--]]

print("[Jhzinn] v6.0 iniciando...")

-- Remove instância anterior
if _G.JhzinnUI then
    pcall(function() _G.JhzinnUI:Destroy() end)
    _G.JhzinnUI = nil
end
_G.JhzinnCarregado = true

--========================= SERVIÇOS =========================
local Jogadores      = game:GetService("Players")
local Renderizacao   = game:GetService("RunService")
local TweenService   = game:GetService("TweenService")
local EspacoTrabalho = game:GetService("Workspace")
local Armazenamento  = game:GetService("ReplicatedStorage")
local StarterGui     = game:GetService("StarterGui")
local ServicoSom     = game:GetService("SoundService")

local JogadorLocal = Jogadores.LocalPlayer
local Camera       = EspacoTrabalho.CurrentCamera
local InterfaceJog = JogadorLocal:WaitForChild("PlayerGui")

print("[Jhzinn] Serviços carregados. Criando UI...")

--========================= CORES =========================
local C = {
    Nome       = "Jhzinn",
    Roxo       = Color3.fromRGB(88, 28, 135),
    RoxoEscuro = Color3.fromRGB(42, 12, 72),
    RoxoClaro  = Color3.fromRGB(170, 110, 255),
    Texto      = Color3.fromRGB(245, 240, 255),
    Apagado    = Color3.fromRGB(175, 155, 215),
    Vermelho   = Color3.fromRGB(230, 40, 40),
    Amarelo    = Color3.fromRGB(245, 200, 40),
    Verde      = Color3.fromRGB(45, 225, 95),
    Azul       = Color3.fromRGB(60, 150, 255),
    RoxoEnt    = Color3.fromRGB(200, 60, 255),
    Branco     = Color3.fromRGB(255, 255, 255),
    Laranja    = Color3.fromRGB(255, 130, 40),
    Ciano      = Color3.fromRGB(80, 230, 230),
    Rosa       = Color3.fromRGB(255, 120, 200),
}

local Opcoes = {
    Portas=true, PortaVerdadeira=true, PortaFalsa=true, PortasTrancadas=true,
    Entidades=true, Itens=true, Objetivos=true,
    Esconderijos=true, Armadilhas=true, Geradores=true, Alavancas=true,
    Minas=true, Arquivos=true, PortaFundos=true,
    ESP=true,
    AutoInteracao=false, SomAlerta=true,
}

--========================= UI PRIMEIRO (BOOT BLINDADO) =========================

local UI = { Paginas = {}, Pronto = false }

local function criarUI()
    local sg = Instance.new("ScreenGui")
    sg.Name = "JhzinnUI"
    sg.ResetOnSpawn = false
    sg.Enabled = true
    sg.DisplayOrder = 2147483647
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.Parent = InterfaceJog
    _G.JhzinnUI = sg

    -- JANELA PRINCIPAL
    local janela = Instance.new("Frame")
    janela.Name = "Janela"
    janela.Size = UDim2.new(0, 500, 0, 560)
    janela.Position = UDim2.new(0.5, -250, 0.5, -280)
    janela.BackgroundColor3 = C.Roxo
    janela.BorderSizePixel = 0
    janela.Active = true
    janela.Draggable = true
    janela.Visible = true
    janela.ZIndex = 2
    janela.Parent = sg

    local grad = Instance.new("UIGradient", janela)
    grad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, C.Roxo),
        ColorSequenceKeypoint.new(1, C.RoxoEscuro),
    }
    grad.Rotation = 135

    local cantos = Instance.new("UICorner", janela)
    cantos.CornerRadius = UDim.new(0, 16)

    local contorno = Instance.new("UIStroke", janela)
    contorno.Color = C.RoxoClaro
    contorno.Thickness = 2
    contorno.Transparency = 0.15

    -- BARRA DO TOPO
    local barraTopo = Instance.new("Frame")
    barraTopo.Size = UDim2.new(1, 0, 0, 44)
    barraTopo.BackgroundColor3 = C.RoxoEscuro
    barraTopo.BorderSizePixel = 0
    barraTopo.ZIndex = 3
    barraTopo.Parent = janela
    Instance.new("UICorner", barraTopo).CornerRadius = UDim.new(0, 16)

    local titulo = Instance.new("TextLabel")
    titulo.Size = UDim2.new(1, -220, 1, 0)
    titulo.Position = UDim2.new(0, 14, 0, 0)
    titulo.BackgroundTransparency = 1
    titulo.Text = "🚪 Jhzinn SISTEMA DOORS v6.0"
    titulo.TextColor3 = C.Texto
    titulo.Font = Enum.Font.GothamBold
    titulo.TextSize = 15
    titulo.TextXAlignment = Enum.TextXAlignment.Left
    titulo.ZIndex = 4
    titulo.Parent = barraTopo

    local marca = Instance.new("TextLabel")
    marca.Size = UDim2.new(0, 90, 0, 20)
    marca.Position = UDim2.new(1, -220, 0, 12)
    marca.BackgroundTransparency = 1
    marca.Text = C.Nome
    marca.TextColor3 = C.RoxoClaro
    marca.Font = Enum.Font.GothamBold
    marca.TextSize = 13
    marca.TextXAlignment = Enum.TextXAlignment.Right
    marca.ZIndex = 4
    marca.Parent = barraTopo

    -- BOTÃO MINIMIZAR
    local btnMin = Instance.new("TextButton")
    btnMin.Size = UDim2.new(0, 30, 0, 30)
    btnMin.Position = UDim2.new(1, -74, 0, 7)
    btnMin.BackgroundColor3 = C.RoxoClaro
    btnMin.Text = "−"
    btnMin.TextColor3 = C.Texto
    btnMin.Font = Enum.Font.GothamBold
    btnMin.TextSize = 22
    btnMin.BorderSizePixel = 0
    btnMin.ZIndex = 5
    btnMin.Parent = barraTopo
    Instance.new("UICorner", btnMin).CornerRadius = UDim.new(0, 8)

    -- BOTÃO FECHAR
    local btnX = Instance.new("TextButton")
    btnX.Size = UDim2.new(0, 30, 0, 30)
    btnX.Position = UDim2.new(1, -40, 0, 7)
    btnX.BackgroundColor3 = Color3.fromRGB(210, 40, 60)
    btnX.Text = "X"
    btnX.TextColor3 = C.Texto
    btnX.Font = Enum.Font.GothamBold
    btnX.TextSize = 15
    btnX.BorderSizePixel = 0
    btnX.ZIndex = 5
    btnX.Parent = barraTopo
    Instance.new("UICorner", btnX).CornerRadius = UDim.new(0, 8)

    -- CORPO
    local corpo = Instance.new("Frame")
    corpo.Size = UDim2.new(1, -20, 1, -56)
    corpo.Position = UDim2.new(0, 10, 0, 50)
    corpo.BackgroundTransparency = 1
    corpo.ZIndex = 3
    corpo.Parent = janela

    -- ABAS
    local barraAbas = Instance.new("Frame")
    barraAbas.Size = UDim2.new(1, 0, 0, 32)
    barraAbas.BackgroundColor3 = C.RoxoEscuro
    barraAbas.BorderSizePixel = 0
    barraAbas.ZIndex = 4
    barraAbas.Parent = corpo
    Instance.new("UICorner", barraAbas).CornerRadius = UDim.new(0, 8)

    local layoutAbas = Instance.new("UIListLayout", barraAbas)
    layoutAbas.FillDirection = Enum.FillDirection.Horizontal
    layoutAbas.Padding = UDim.new(0, 3)
    layoutAbas.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layoutAbas.VerticalAlignment = Enum.VerticalAlignment.Center

    local paginas = Instance.new("Frame")
    paginas.Size = UDim2.new(1, 0, 1, -40)
    paginas.Position = UDim2.new(0, 0, 0, 40)
    paginas.BackgroundTransparency = 1
    paginas.ZIndex = 3
    paginas.Parent = corpo

    local function criarAba(nome, largura)
        local pg = Instance.new("ScrollingFrame")
        pg.Size = UDim2.new(1, 0, 1, 0)
        pg.BackgroundTransparency = 1
        pg.BorderSizePixel = 0
        pg.ScrollBarThickness = 4
        pg.ScrollBarImageColor3 = C.RoxoClaro
        pg.CanvasSize = UDim2.new(0, 0, 0, 0)
        pg.AutomaticCanvasSize = Enum.AutomaticSize.Y
        pg.Visible = false
        pg.ZIndex = 4
        pg.Parent = paginas

        local l = Instance.new("UIListLayout", pg)
        l.SortOrder = Enum.SortOrder.LayoutOrder
        l.Padding = UDim.new(0, 6)

        UI.Paginas[nome] = pg

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, largura or 78, 0, 24)
        btn.BackgroundColor3 = C.Roxo
        btn.Text = nome
        btn.TextColor3 = C.Texto
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 10
        btn.BorderSizePixel = 0
        btn.ZIndex = 5
        btn.Parent = barraAbas
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

        btn.MouseButton1Click:Connect(function()
            for _, p in pairs(UI.Paginas) do p.Visible = false end
            pg.Visible = true
        end)

        return pg
    end

    -- ABA STATUS
    local pgStatus = criarAba("STATUS", 60)

    local function criarLinha(parent, chave)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, 0, 0, 26)
        f.BackgroundColor3 = C.RoxoEscuro
        f.BorderSizePixel = 0
        f.ZIndex = 5
        f.Parent = parent
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)

        local k = Instance.new("TextLabel")
        k.Size = UDim2.new(0.5, -8, 1, 0)
        k.Position = UDim2.new(0, 10, 0, 0)
        k.BackgroundTransparency = 1
        k.Text = chave
        k.TextColor3 = C.Apagado
        k.Font = Enum.Font.Gotham
        k.TextSize = 12
        k.TextXAlignment = Enum.TextXAlignment.Left
        k.ZIndex = 6
        k.Parent = f

        local v = Instance.new("TextLabel")
        v.Size = UDim2.new(0.5, -8, 1, 0)
        v.Position = UDim2.new(0.5, 0, 0, 0)
        v.BackgroundTransparency = 1
        v.Text = "-"
        v.TextColor3 = C.Texto
        v.Font = Enum.Font.GothamBold
        v.TextSize = 12
        v.TextXAlignment = Enum.TextXAlignment.Right
        v.ZIndex = 6
        v.Parent = f

        return v
    end

    UI.lblAndar = criarLinha(pgStatus, "ANDAR")
    UI.lblSala  = criarLinha(pgStatus, "SALA")
    UI.lblProx  = criarLinha(pgStatus, "PRÓXIMA PORTA")
    UI.lblEnt   = criarLinha(pgStatus, "ENTIDADE ATIVA")
    UI.lblAnti  = criarLinha(pgStatus, "ANTI-BAN")
    UI.lblAuto  = criarLinha(pgStatus, "AUTO-INTERAÇÃO")

    -- ABA OPÇÕES
    local pgOpcoes = criarAba("OPÇÕES", 70)

    local function criarToggle(nome, chave)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, 0, 0, 28)
        f.BackgroundColor3 = C.RoxoEscuro
        f.BorderSizePixel = 0
        f.ZIndex = 5
        f.Parent = pgOpcoes
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)

        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(0.7, 0, 1, 0)
        l.Position = UDim2.new(0, 12, 0, 0)
        l.BackgroundTransparency = 1
        l.Text = nome
        l.TextColor3 = C.Texto
        l.Font = Enum.Font.Gotham
        l.TextSize = 12
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.ZIndex = 6
        l.Parent = f

        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 56, 0, 20)
        b.Position = UDim2.new(1, -66, 0, 4)
        b.BackgroundColor3 = Opcoes[chave] and C.Verde or Color3.fromRGB(120,120,140)
        b.Text = Opcoes[chave] and "LIG" or "DES"
        b.TextColor3 = C.Texto
        b.Font = Enum.Font.GothamBold
        b.TextSize = 11
        b.BorderSizePixel = 0
        b.ZIndex = 6
        b.Parent = f
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)

        b.MouseButton1Click:Connect(function()
            Opcoes[chave] = not Opcoes[chave]
            b.Text = Opcoes[chave] and "LIG" or "DES"
            b.BackgroundColor3 = Opcoes[chave] and C.Verde or Color3.fromRGB(120,120,140)
        end)
    end

    criarToggle("Portas","Portas")
    criarToggle("Porta Verdadeira","PortaVerdadeira")
    criarToggle("Porta Falsa","PortaFalsa")
    criarToggle("Portas Trancadas","PortasTrancadas")
    criarToggle("Entidades","Entidades")
    criarToggle("Itens","Itens")
    criarToggle("Objetivos","Objetivos")
    criarToggle("Esconderijos","Esconderijos")
    criarToggle("Armadilhas","Armadilhas")
    criarToggle("Geradores","Geradores")
    criarToggle("Alavancas","Alavancas")
    criarToggle("As Minas","Minas")
    criarToggle("Os Arquivos","Arquivos")
    criarToggle("Porta dos Fundos","PortaFundos")
    criarToggle("ESP","ESP")

    -- ABA AUTO
    local pgAuto = criarAba("AUTO", 60)
    criarToggle("Auto-Interação","AutoInteracao")
    criarToggle("Som de Alerta","SomAlerta")

    -- ABA LOGS
    local pgLogs = criarAba("LOGS", 60)
    UI.PainelLogs = pgLogs

    -- Ativa primeira aba
    pgStatus.Visible = true

    -- BOTÃO FLUTUANTE
    local flutuante = Instance.new("TextButton")
    flutuante.Size = UDim2.new(0, 62, 0, 62)
    flutuante.Position = UDim2.new(0, 24, 0.5, -31)
    flutuante.BackgroundColor3 = C.Roxo
    flutuante.Text = "J"
    flutuante.TextColor3 = C.Texto
    flutuante.Font = Enum.Font.GothamBold
    flutuante.TextSize = 26
    flutuante.BorderSizePixel = 0
    flutuante.Visible = false
    flutuante.Active = true
    flutuante.Draggable = true
    flutuante.ZIndex = 10
    flutuante.Parent = sg
    Instance.new("UICorner", flutuante).CornerRadius = UDim.new(1, 0)
    local contFlut = Instance.new("UIStroke", flutuante)
    contFlut.Color = C.RoxoClaro
    contFlut.Thickness = 2

    -- EVENTOS BOTÕES
    btnMin.MouseButton1Click:Connect(function()
        janela.Visible = false
        flutuante.Visible = true
    end)

    flutuante.MouseButton1Click:Connect(function()
        janela.Visible = true
        flutuante.Visible = false
    end)

    btnX.MouseButton1Click:Connect(function()
        sg:Destroy()
        _G.JhzinnUI = nil
    end)

    UI.Janela = janela
    UI.Pronto = true
    return true
end

-- CHAMA A CRIAÇÃO DA UI
local okUI, errUI = pcall(criarUI)
if not okUI then
    warn("[Jhzinn] ❌ Erro ao criar UI:", errUI)
    return
end

print("[Jhzinn] ✅ UI criada com sucesso!")

--========================= FUNÇÃO DE LOG =========================
function UI:Registrar(texto, cor)
    if not self.PainelLogs then return end
    local rot = Instance.new("TextLabel")
    rot.Size = UDim2.new(1, 0, 0, 16)
    rot.BackgroundTransparency = 1
    rot.Text = "["..os.date("%H:%M:%S").."] "..texto
    rot.TextColor3 = cor or C.Apagado
    rot.Font = Enum.Font.Code
    rot.TextSize = 11
    rot.TextXAlignment = Enum.TextXAlignment.Left
    rot.ZIndex = 6
    rot.Parent = self.PainelLogs

    local filhos = self.PainelLogs:GetChildren()
    local n = 0
    for _, f in ipairs(filhos) do
        if f:IsA("TextLabel") then n = n + 1 end
    end
    if n > 80 then
        for _, f in ipairs(filhos) do
            if f:IsA("TextLabel") then f:Destroy(); break end
        end
    end
end

UI:Registrar("SISTEMA v6.0 iniciado", C.RoxoClaro)
UI:Registrar("UI carregada com sucesso", C.Verde)

--========================= HIGHLIGHT MANAGER =========================
local GerDestaque = { Cache = {}, Avisos = {} }

function GerDestaque:Aplicar(obj, cor, texto)
    if not obj or not obj.Parent then return end
    if self.Cache[obj] then self.Cache[obj]:Destroy() end
    if self.Avisos[obj] then self.Avisos[obj]:Destroy() end

    local hl = Instance.new("Highlight")
    hl.FillColor = cor
    hl.OutlineColor = cor
    hl.FillTransparency = 0.55
    hl.OutlineTransparency = 0
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Adornee = obj
    hl.Parent = obj
    self.Cache[obj] = hl

    if texto then
        local bb = Instance.new("BillboardGui")
        bb.Size = UDim2.new(0, 200, 0, 40)
        bb.StudsOffset = Vector3.new(0, 4, 0)
        bb.AlwaysOnTop = true
        bb.Adornee = obj
        bb.Parent = obj

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = texto
        lbl.TextColor3 = cor
        lbl.TextStrokeTransparency = 0.2
        lbl.TextStrokeColor3 = Color3.new(0,0,0)
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 13
        lbl.TextWrapped = true
        lbl.Parent = bb
        self.Avisos[obj] = bb
    end
end

function GerDestaque:Limpar(obj)
    if self.Cache[obj] then self.Cache[obj]:Destroy(); self.Cache[obj]=nil end
    if self.Avisos[obj] then self.Avisos[obj]:Destroy(); self.Avisos[obj]=nil end
end

function GerDestaque:LimparTudo()
    for _, v in pairs(self.Cache) do v:Destroy() end
    for _, v in pairs(self.Avisos) do v:Destroy() end
    self.Cache = {}
    self.Avisos = {}
end

--========================= SOM =========================
local GerSom = {}
do
    local som = Instance.new("Sound")
    som.Name = "JhzinnAlerta"
    som.SoundId = "rbxasset://sounds/electronicpingshort.wav"
    som.Volume = 1.5
    som.Parent = ServicoSom
    GerSom.Som = som
end

function GerSom:Tocar()
    if not Opcoes.SomAlerta then return end
    pcall(function()
        GerSom.Som:Stop()
        GerSom.Som:Play()
    end)
end

--========================= NOTIFICAÇÕES (DIREITA) =========================
local GerNotificacao = { Quadros = {} }
do
    local suporte = Instance.new("Frame")
    suporte.Name = "JhzinnNotificacoes"
    suporte.Size = UDim2.new(0, 260, 1, -40)
    suporte.Position = UDim2.new(1, -272, 0, 20)
    suporte.BackgroundTransparency = 1
    suporte.ZIndex = 9999
    suporte.Parent = _G.JhzinnUI

    local layout = Instance.new("UIListLayout", suporte)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.VerticalAlignment = Enum.VerticalAlignment.Top
    layout.Padding = UDim.new(0, 6)

    GerNotificacao.Suporte = suporte
end

function GerNotificacao:Enviar(titulo, cor)
    local quadro = Instance.new("Frame")
    quadro.Size = UDim2.new(1, 0, 0, 46)
    quadro.BackgroundColor3 = C.RoxoEscuro
    quadro.BackgroundTransparency = 0.1
    quadro.BorderSizePixel = 0
    quadro.ZIndex = 10000
    quadro.Parent = self.Suporte
    Instance.new("UICorner", quadro).CornerRadius = UDim.new(0, 10)

    local cont = Instance.new("UIStroke", quadro)
    cont.Color = cor
    cont.Thickness = 2

    local barra = Instance.new("Frame")
    barra.Size = UDim2.new(0, 5, 1, -8)
    barra.Position = UDim2.new(0, 4, 0, 4)
    barra.BackgroundColor3 = cor
    barra.BorderSizePixel = 0
    barra.ZIndex = 10001
    barra.Parent = quadro
    Instance.new("UICorner", barra).CornerRadius = UDim.new(0, 3)

    local rot = Instance.new("TextLabel")
    rot.Size = UDim2.new(1, -20, 1, 0)
    rot.Position = UDim2.new(0, 16, 0, 0)
    rot.BackgroundTransparency = 1
    rot.Text = titulo
    rot.TextColor3 = C.Texto
    rot.Font = Enum.Font.GothamBold
    rot.TextSize = 14
    rot.TextXAlignment = Enum.TextXAlignment.Left
    rot.ZIndex = 10001
    rot.Parent = quadro

    table.insert(self.Quadros, quadro)
    task.delay(4, function()
        if quadro and quadro.Parent then
            TweenService:Create(quadro, TweenInfo.new(0.3), {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 0)
            }):Play()
            task.wait(0.3)
            quadro:Destroy()
        end
    end)

    if #self.Quadros > 6 then
        local velho = table.remove(self.Quadros, 1)
        if velho then velho:Destroy() end
    end
end

--========================= DETECTOR DE ANDAR =========================
local DetectorAndar = { Andar = "Hotel" }

function DetectorAndar:Atualizar()
    local dados = Armazenamento:FindFirstChild("GameData")
    if dados then
        local andar = dados:FindFirstChild("Floor")
        if andar and andar.Value then self.Andar = tostring(andar.Value) end
        local salaRecente = dados:FindFirstChild("LatestRoom")
        if salaRecente and salaRecente.Value then
            local num = tonumber(salaRecente.Value)
            if num and num < 0 then self.Andar = "PortaFundos" end
        end
    end
    if self.Andar == "Hotel" then
        for _, obj in ipairs(EspacoTrabalho:GetDescendants()) do
            if obj.Name == "Generator" or obj.Name == "Fuse" then
                self.Andar = "Minas"
                break
            end
        end
    end
end

--========================= DETECTOR DE PORTAS =========================
local DetectorPortas = { Sala = 0 }

local function pegarNumero(texto)
    return tonumber(string.match(texto or "", "%-?%d+"))
end

function DetectorPortas:Atualizar()
    if not Opcoes.Portas then return end
    local portas = {}
    for _, obj in ipairs(EspacoTrabalho:GetDescendants()) do
        if (obj:IsA("Model") or obj:IsA("BasePart")) then
            local nome = obj.Name
            if (string.find(nome, "Door") or string.find(nome, "door") or
                string.find(nome, "Exit") or string.find(nome, "Porta"))
               and not string.find(nome, "Frame") then
                local num = pegarNumero(nome)
                if num then
                    table.insert(portas, {obj = obj, 
