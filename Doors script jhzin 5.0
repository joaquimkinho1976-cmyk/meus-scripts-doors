--[[
    ═══════════════════════════════════════════════════════════════════════════
    Jhzinn SISTEMA DOORS v5.0  [EDIÇÃO ELITE]
    Hotel · Minas · Arquivos · Porta dos Fundos · Escadaria
    ESP Itens · Notificação Direita · Som · Auto-Interação · Anti-Ban
    ═══════════════════════════════════════════════════════════════════════════
--]]

if _G.JhzinnCarregado then
    pcall(function() _G.JhzinnUI:Destroy() end)
end
_G.JhzinnCarregado = true

--========================= SERVIÇOS =========================
local Jogadores         = game:GetService("Players")
local Renderizacao      = game:GetService("RunService")
local EntradaUsuario    = game:GetService("UserInputService")
local ServicoTween      = game:GetService("TweenService")
local EspacoTrabalho    = game:GetService("Workspace")
local ArmazenamentoRep  = game:GetService("ReplicatedStorage")
local StarterGui        = game:GetService("StarterGui")
local ServicoSom        = game:GetService("SoundService")

local JogadorLocal = Jogadores.LocalPlayer
local Camera       = EspacoTrabalho.CurrentCamera
local InterfaceJog = JogadorLocal:WaitForChild("PlayerGui")

--========================= ANTI-BAN (INICIALIZAÇÃO) =========================
local AntiBan = { Ativo = true, Recursos = {
    hookmetamethod = type(hookmetamethod) == "function",
    hookfunction   = type(hookfunction) == "function",
    gethwid        = type(gethwid) == "function",
    getgc          = type(getgc) == "function",
    checkcaller    = type(checkcaller) == "function",
    newcclosure    = type(newcclosure) == "function",
} }

if AntiBan.Recursos.hookmetamethod and AntiBan.Recursos.newcclosure then
    pcall(function()
        local mt = getrawmetatable(game)
        local antigo = mt.__namecall
        setreadonly(mt, false)
        mt.__namecall = newcclosure(function(self, ...)
            local metodo = getnamecallmethod()
            if metodo == "Kick" and AntiBan.Ativo then
                warn("[Jhzinn] Kick bloqueado"); return
            end
            if metodo == "FireServer" and AntiBan.Ativo then
                local nome = string.lower(tostring(self))
                if nome:find("ban") or nome:find("kick")
                   or nome:find("anticheat") or nome:find("detect")
                   or nome:find("report") then
                    warn("[Jhzinn] Remote bloqueado: "..tostring(self)); return
                end
            end
            return antigo(self, ...)
        end)
        setreadonly(mt, true)
    end)
end

if AntiBan.Recursos.hookfunction and AntiBan.Recursos.gethwid then
    pcall(function()
        hookfunction(gethwid, function()
            return "Jhzinn-Falso-"..tostring(math.random(1e5,1e6))
        end)
    end)
end

--========================= CONFIGURAÇÕES =========================
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
    Portas=true, PortaVerdadeira=true, PortaFalsa=true,
    PortasTrancadas=true,
    Entidades=true, Itens=true, Objetivos=true,
    Esconderijos=true, Armadilhas=true, Geradores=true,
    Alavancas=true, Distancias=true, Numeros=true,
    Minas=true, Arquivos=true, PortaFundos=true,
    ESP=true, Depurar=false,
    AutoInteracao=false,
    SomAlerta=true,
    AntiKick=true, AntiBanRemoto=true, FalsoHWID=true,
    AntiDeteccao=true, ModoSeguro=true,
}

--========================= GERENCIADOR DE DESTAQUES =========================
local GerDestaque = { Cache = {}, Avisos = {} }
_G.JhzinnGerDestaque = GerDestaque

function GerDestaque:Aplicar(obj, cor, texto)
    if not obj then return end
    if self.Cache[obj] then self.Cache[obj]:Destroy() end
    if self.Avisos[obj] then self.Avisos[obj]:Destroy() end

    local destaque = Instance.new("Highlight")
    destaque.FillColor = cor; destaque.OutlineColor = cor
    destaque.FillTransparency = 0.55; destaque.OutlineTransparency = 0
    destaque.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    destaque.Adornee = obj; destaque.Parent = obj
    self.Cache[obj] = destaque

    if texto then
        local aviso = Instance.new("BillboardGui")
        aviso.Size = UDim2.new(0, 200, 0, 40)
        aviso.StudsOffset = Vector3.new(0, 4, 0)
        aviso.AlwaysOnTop = true; aviso.Adornee = obj; aviso.Parent = obj
        local rotulo = Instance.new("TextLabel")
        rotulo.Size = UDim2.new(1, 0, 1, 0)
        rotulo.BackgroundTransparency = 1
        rotulo.Text = texto; rotulo.TextColor3 = cor
        rotulo.TextStrokeTransparency = 0.2
        rotulo.TextStrokeColor3 = Color3.new(0,0,0)
        rotulo.Font = Enum.Font.GothamBold; rotulo.TextSize = 13
        rotulo.TextWrapped = true; rotulo.Parent = aviso
        self.Avisos[obj] = aviso
    end
end

function GerDestaque:Limpar(obj)
    if self.Cache[obj] then self.Cache[obj]:Destroy(); self.Cache[obj]=nil end
    if self.Avisos[obj] then self.Avisos[obj]:Destroy(); self.Avisos[obj]=nil end
end

function GerDestaque:LimparTudo()
    for _,v in pairs(self.Cache) do v:Destroy() end
    for _,v in pairs(self.Avisos) do v:Destroy() end
    self.Cache={}; self.Avisos={}
end

local function distancia(obj)
    if not obj or not Camera then return 0 end
    local pos = obj:IsA("Model") and obj:GetPivot().Position or obj.Position
    return math.floor((Camera.CFrame.Position - pos).Magnitude)
end

--========================= GERENCIADOR DE SOM =========================
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
    suporte.Parent = InterfaceJog
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
    quadro.Parent = self.Suporte
    Instance.new("UICorner", quadro).CornerRadius = UDim.new(0, 10)
    local contorno = Instance.new("UIStroke", quadro)
    contorno.Color = cor; contorno.Thickness = 2

    local barra = Instance.new("Frame")
    barra.Size = UDim2.new(0, 5, 1, -8)
    barra.Position = UDim2.new(0, 4, 0, 4)
    barra.BackgroundColor3 = cor
    barra.BorderSizePixel = 0
    barra.Parent = quadro
    Instance.new("UICorner", barra).CornerRadius = UDim.new(0, 3)

    local rotulo = Instance.new("TextLabel")
    rotulo.Size = UDim2.new(1, -20, 1, 0)
    rotulo.Position = UDim2.new(0, 16, 0, 0)
    rotulo.BackgroundTransparency = 1
    rotulo.Text = titulo
    rotulo.TextColor3 = C.Texto
    rotulo.Font = Enum.Font.GothamBold
    rotulo.TextSize = 14
    rotulo.TextXAlignment = Enum.TextXAlignment.Left
    rotulo.Parent = quadro

    quadro.BackgroundTransparency = 1
    ServicoTween:Create(quadro, TweenInfo.new(0.2), {BackgroundTransparency = 0.1}):Play()

    table.insert(self.Quadros, quadro)
    task.delay(4, function()
        if quadro and quadro.Parent then
            ServicoTween:Create(quadro, TweenInfo.new(0.3), {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 0)
            }):Play()
            task.wait(0.3)
            quadro:Destroy()
        end
    end)

    if #self.Quadros > 6 then
        local antigo = table.remove(self.Quadros, 1)
        if antigo then antigo:Destroy() end
    end
end

--========================= DETECÇÃO DE ANDAR =========================
local DetectorAndar = { Andar = "Hotel" }
function DetectorAndar:Atualizar()
    local dados = ArmazenamentoRep:FindFirstChild("GameData")
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
            if obj.Name == "Generator" or obj.Name == "Fuse" then self.Andar = "Minas" break end
            if obj.Name == "Teller" or obj.Name == "Honcho" then self.Andar = "Arquivos" break end
        end
    end
end

--========================= DETECTOR DE PORTAS =========================
local DetectorPortas = { Sala=0, PortaVerdadeira=nil }

local function extrairNumero(texto) return tonumber(string.match(texto or "", "%-?%d+")) end

function DetectorPortas:Atualizar()
    if not Opcoes.Portas then return end
    local portas = {}
    for _, obj in ipairs(EspacoTrabalho:GetDescendants()) do
        if (obj:IsA("Model") or obj:IsA("BasePart")) and
           (string.find(obj.Name,"Door") or string.find(obj.Name,"door") or
            string.find(obj.Name,"Exit") or string.find(obj.Name,"Porta")) and
           not string.find(obj.Name,"Frame") then
            local num = extrairNumero(obj.Name)
            if num then table.insert(portas, {obj=obj, num=num}) end
        end
    end
    if #portas==0 then return end

    table.sort(portas, function(a,b) return a.num<b.num end)
    local menor = portas[1].num
    if menor ~= self.Sala then
        self.Sala = menor
    end

    local esperada = self.Sala + 1
    if DetectorAndar.Andar == "PortaFundos" then esperada = self.Sala - 1 end

    for _, porta in ipairs(portas) do
        if porta.num == esperada and Opcoes.PortaVerdadeira then
            GerDestaque:Aplicar(porta.obj, C.Vermelho, "🔴 PORTA VERDADEIRA #"..porta.num)
        elseif Opcoes.PortaFalsa and porta.num ~= self.Sala
           and math.abs(porta.num - esperada) <= 5 and porta.num ~= esperada then
            GerDestaque:Aplicar(porta.obj, C.Amarelo, "🟡 PORTA FALSA #"..porta.num)
        elseif Opcoes.PortasTrancadas then
            local trancada = porta.obj:GetAttribute("Locked") or
                (porta.obj:FindFirstChild("Locked") and porta.obj.Locked.Value) or false
            if trancada then
                GerDestaque:Aplicar(porta.obj, C.Laranja, "🔒 TRANCADA #"..porta.num)
            end
        end
    end
end

--========================= DETECTOR DE ENTIDADES =========================
local DetectorEntidades = {}
DetectorEntidades.Lista = {
    {n="Rush",     ids={"RushMoving","Rush","BackdoorRush"}, c=C.Vermelho},
    {n="Ambush",   ids={"AmbushMoving","Ambush"},             c=C.Laranja},
    {n="Screech",  ids={"Screech"},                           c=C.Branco},
    {n="Eyes",     ids={"Eyes"},                              c=C.Amarelo},
    {n="Seek",     ids={"SeekMoving","Seek","SeekBlob"},      c=C.RoxoEnt},
    {n="Figure",   ids={"FigureRig","Figure"},                c=C.Branco},
    {n="Hide",     ids={"Hide"},                              c=C.RoxoClaro},
    {n="Dupe",     ids={"Dupe"},                              c=C.Amarelo},
    {n="Snare",    ids={"Snare"},                             c=C.Laranja},
    {n="Dread",    ids={"Dread"},                             c=C.Vermelho},
    {n="Halt",     ids={"Halt"},                              c=C.Ciano},
    {n="Giggle",   ids={"Giggle"},                            c=C.Laranja},
    {n="Gloombats",ids={"Gloombats","Gloombat"},              c=C.RoxoEnt},
    {n="Grumble",  ids={"Grumble"},                           c=C.Vermelho},
    {n="QueenGrumble",ids={"QueenGrumble"},                   c=C.Vermelho},
    {n="Honcho",   ids={"Honcho"},                            c=C.RoxoEnt},
    {n="Drone",    ids={"Drone","Drones"},                    c=C.RoxoClaro},
    {n="Teller",   ids={"Teller"},                            c=C.Ciano},
    {n="Alma",     ids={"Alma"},                              c=C.RoxoEnt},
    {n="Ransom",   ids={"Ransom","monster2"},                 c=C.Vermelho},
    {n="Bash",     ids={"Bash","A60"},                        c=C.Laranja},
    {n="Scribbles",ids={"Scribbles","Scribble"},              c=C.Amarelo},
    {n="ForgetMeNot",ids={"Forget-Me-Not","ForgetMeNot"},     c=C.Azul},
    {n="Portrait", ids={"Portrait"},                          c=C.RoxoClaro},
    {n="Fih",      ids={"Fih"},                               c=C.Ciano},
    {n="Noise",    ids={"Noise"},                             c=C.Branco},
    {n="Haste",    ids={"Haste"},                             c=C.Ciano},
    {n="Blitz",    ids={"Blitz"},                             c=C.Verde},
    {n="Creak",    ids={"Creak"},                             c=C.RoxoEnt},
    {n="Meld",     ids={"Meld"},                              c=C.Laranja},
    {n="Stem",     ids={"Stem"},                              c=C.Azul},
    {n="Cobbler",  ids={"Cobbler"},                           c=C.Branco},
}
DetectorEntidades.Ativas = {}

function DetectorEntidades:Atualizar()
    if not Opcoes.Entidades then return end
    local encontradas = {}
    for _, obj in ipairs(EspacoTrabalho:GetDescendants()) do
        if obj.Name and obj.Name ~= "" then
            for _, ent in ipairs(self.Lista) do
                for _, id in ipairs(ent.ids) do
                    if obj.Name == id and not encontradas[ent.n] then
                        encontradas[ent.n] = {obj=obj, dados=ent} break
                    end
                end
            end
        end
    end
    for nome, info in pairs(encontradas) do
        if not self.Ativas[nome] then
            self.Ativas[nome] = info
            GerDestaque:Aplicar(info.obj, info.dados.c, "👾 "..nome)
            GerNotificacao:Enviar("👾 "..nome, info.dados.c)
            GerSom:Tocar()
            if UI.PainelLogs then UI:Registrar("ENTIDADE "..nome, info.dados.c) end
        end
    end
    for nome, info in pairs(self.Ativas) do
        if not encontradas[nome] then
            GerDestaque:Limpar(info.obj)
            self.Ativas[nome] = nil
        end
    end
end

--========================= DETECTOR DE ITENS (ESP) =========================
local DetectorItens = {}
DetectorItens.Lista = {
    {n="Chave",         ids={"Key","KeyDoor","RoomKey"},              c=C.Azul},
    {n="Chave Mestra",  ids={"SkeletonKey","Skeleton_Key"},           c=C.RoxoEnt},
    {n="Gazuа",         ids={"Lockpick","LockPick"},                  c=C.Ciano},
    {n="Crucifixo",     ids={"Crucifix"},                             c=C.Branco},
    {n="Bandagem",      ids={"Bandage","BandagePack"},                c=C.Verde},
    {n="Vitaminas",     ids={"Vitamins"},                             c=C.Verde},
    {n="Lanterna",      ids={"Flashlight"},                           c=C.Amarelo},
    {n="Lanterna Chacoalhante", ids={"Shakelight"},                   c=C.Amarelo},
    {n="Tesoura",       ids={"Shears"},                               c=C.Rosa},
    {n="Vela",          ids={"Candle","CandleItem"},                  c=C.Amarelo},
    {n="Isqueiro",      ids={"Lighter"},                              c=C.Laranja},
    {n="Bússola",       ids={"Compass"},                              c=C.Ciano},
    {n="Ouro",          ids={"Gold","GoldCoin"},                      c=C.Amarelo},
}

function DetectorItens:Atualizar()
    if not Opcoes.Itens then return end
    for _, obj in ipairs(EspacoTrabalho:GetDescendants()) do
        if not obj.Name or obj.Name == "" then continue end
        for _, item in ipairs(self.Lista) do
            for _, id in ipairs(item.ids) do
                if obj.Name == id then
                    GerDestaque:Aplicar(obj, item.c, "🔵 "..item.n)
                    break
                end
            end
        end
    end
end

--========================= DETECTOR DE OBJETIVOS =========================
local DetectorObjetivos = {}
DetectorObjetivos.Lista = {
    {n="Esconderijo", ids={"Wardrobe","Closet","Locker","Bed"},   c=C.Verde},
    {n="Gerador",     ids={"Generator","Fuse"},                   c=C.Verde},
    {n="Alavanca",    ids={"Lever","RailLever","AnchorLever","TimeLever","TimerLever"}, c=C.Verde},
    {n="Elevador",    ids={"Elevator"},                           c=C.Ciano},
    {n="Terminal",    ids={"Terminal","Computer"},                c=C.Ciano},
    {n="Carrinho",    ids={"Minecart"},                           c=C.Azul},
    {n="Âncora",      ids={"Anchor"},                             c=C.Ciano},
    {n="Bebedouro",   ids={"WaterCooler"},                        c=C.Azul},
}

function DetectorObjetivos:Atualizar()
    if not Opcoes.Objetivos and not Opcoes.Esconderijos
       and not Opcoes.Geradores and not Opcoes.Alavancas then return end
    for _, obj in ipairs(EspacoTrabalho:GetDescendants()) do
        if not obj.Name or obj.Name == "" then continue end
        for _, alvo in ipairs(self.Lista) do
            for _, id in ipairs(alvo.ids) do
                if obj.Name == id then
                    local permitido = Opcoes.Objetivos
                        or (alvo.n=="Esconderijo" and Opcoes.Esconderijos)
                        or (alvo.n=="Gerador" and Opcoes.Geradores)
                        or (alvo.n=="Alavanca" and Opcoes.Alavancas)
                    if permitido then
                        GerDestaque:Aplicar(obj, alvo.c, "🟢 "..alvo.n)
                    end
                    break
                end
            end
        end
    end
end

--========================= DETECTOR DE ARMADILHAS =========================
local DetectorArmadilhas = {}
function DetectorArmadilhas:Atualizar()
    if not Opcoes.Armadilhas then return end
    for _, obj in ipairs(EspacoTrabalho:GetDescendants()) do
        if obj.Name == "Snare" or obj.Name == "Trap" or obj.Name == "MothEgg" then
            GerDestaque:Aplicar(obj, C.Laranja, "⚠ ARMADILHA")
        end
    end
end

--========================= MINAS / ARQUIVOS / PORTA DOS FUNDOS =========================
local DetectorMinas = {}
function DetectorMinas:Atualizar()
    if not Opcoes.Minas then return end
    if DetectorAndar.Andar ~= "Minas" then return end
    for _, obj in ipairs(EspacoTrabalho:GetDescendants()) do
        local n = obj.Name
        if n == "Fuse" then GerDestaque:Aplicar(obj, C.Azul, "🔵 FUSÍVEL")
        elseif n == "Generator" then GerDestaque:Aplicar(obj, C.Verde, "⚙ GERADOR")
        elseif n == "RailLever" then GerDestaque:Aplicar(obj, C.Verde, "🎚 TRILHO")
        elseif n == "AnchorLever" then GerDestaque:Aplicar(obj, C.Verde, "⚓ ÂNCORA")
        elseif n == "Minecart" then GerDestaque:Aplicar(obj, C.Azul, "🛒 CARRINHO")
        elseif n == "Anchor" then GerDestaque:Aplicar(obj, C.Ciano, "⚓ ÂNCORA")
        end
    end
end

local DetectorArquivos = {}
function DetectorArquivos:Atualizar()
    if not Opcoes.Arquivos then return end
    if DetectorAndar.Andar 
