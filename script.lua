local a=cloneref or(function(...)return...end)

local b=delfolder or deletefolder
local c=delfile or deletefile
local d=makefolder
local e=writefile
local f=readfile

local g=setmetatable({},{
__index=function(g,h)
rawset(g,h,a(game:GetService(h)))
return rawget(g,h)
end
})

local h=g.MarketplaceService
local i=g.UserInputService
local j=g.TweenService
local k=g.HttpService
local l=g.RunService
local m=g.Players

local n=l.Heartbeat

local o=m.LocalPlayer
local p=o:GetMouse()

local q=(gethui or function()return g.CoreGui end)()

-- [[ THEME MODIFICATION: ROYAL OBSIDIAN ]] --
local r={
Darker={
Colors={
Background=ColorSequence.new{
ColorSequenceKeypoint.new(0.00,Color3.fromRGB(15,15,17)),
ColorSequenceKeypoint.new(0.50,Color3.fromRGB(10,10,12)),
ColorSequenceKeypoint.new(1.00,Color3.fromRGB(15,15,17))
},
Primary=Color3.fromRGB(212,175,55), -- Champagne Gold
OnPrimary=Color3.fromRGB(18,18,20), -- Dark Text on Gold
ScrollBar=Color3.fromRGB(212,175,55),
Stroke=Color3.fromRGB(60,60,60),

Error=Color3.fromRGB(255,85,85),
Icons=Color3.fromRGB(245,245,245), -- Pure White Icons

JoinButton=Color3.fromRGB(37,128,69),
Link=Color3.fromRGB(64,160,255),

Dialog={
Background=Color3.fromRGB(20,20,22)
},
Buttons={
Holding=Color3.fromRGB(45,45,47),
Default=Color3.fromRGB(30,30,32)
},
Border={
Holding=Color3.fromRGB(212,175,55), -- Gold Border on Hold
Default=Color3.fromRGB(50,50,50),
},
Text={
Default=Color3.fromRGB(255,255,255),
Dark=Color3.fromRGB(210,210,210),
Darker=Color3.fromRGB(160,160,160),
},
Slider={
SliderBar=Color3.fromRGB(40,40,42),
SliderNumber=Color3.fromRGB(255,255,255),
},
Dropdown={
Holder=Color3.fromRGB(25,25,27),
}
},
Icons={
Error="rbxassetid://10709752996",
Button="rbxassetid://10709791437",
Close="rbxassetid://10747384394",
TextBox="rbxassetid://15637081879",
Search="rbxassetid://10734943674",
Keybind="rbxassetid://10734982144",
Dropdown={
Open="rbxassetid://10709791523",
Close="rbxassetid://10709790948"
}
},
Font={
Normal=Enum.Font.GothamMedium,    -- Upgraded Font
Medium=Enum.Font.GothamSemibold,  -- Upgraded Font
Bold=Enum.Font.GothamBold,        -- Upgraded Font
ExtraBold=Enum.Font.GothamBlack,  -- Upgraded Font
SliderValue=Enum.Font.RobotoMono
},
BackgroundTransparency=0.05
}
}
-- [[ END OF THEME MODIFICATION ]] --

for s,t in r do
t.Name=s
table.freeze(t)
end

local s={
Information={
Version="v2.0.1 - Royal Edition",
GitHubOwner="tlredz"
},
Default={
Theme="Darker",
UISize=UDim2.fromOffset(550,380),
TabSize=160
},

Themes=r,

Connections={},
Options={},
Tabs={}
}

s.Info=s.Information
s.Save=s.Default

local t=workspace.CurrentCamera.ViewportSize local u=function(

u, v, w)
table.insert(s.Connections,u[w or"Connect"](u,v))end


local v={}
v.__index=v local w=function(

w, x)
for y in x:gmatch"[^%.]+"do
w=w[y]
end

return w end local x=function(


x, y, z, A)
if not A then
A=s.CurrentTheme
end

x[y]=w(A,if type(z)=="function"then z()else z)end local y=function(


y, z, A)
for B,C in A do
x(z,B,C,y)
end end local z=function(


z, A)
if d then
local B=z:split"/"
B[#B]=nil

local C=table.concat(B,"/")

if C~=""and(isfolder==nil or not isfolder(C))then
d(C)
end
end

e(z,A)end


local A=false

local B={
MAX_SCALE=1.6,
MIN_SCALE=0.6,

TEXTBOX={
PLACEHOLDER_TEXT="Input"
}
}

function v:add(C,D)
self.Descendants[D]=C

if self.IS_RENDERING then
y(s.CurrentTheme,C,D)
end
end

function v:update()
if self.IS_RENDERING and not self.UPDATED_OBJECTS then
local C=s.CurrentTheme
self.UPDATED_OBJECTS=true

for D,E in self.Descendants do
local F=typeof(E)
if F=="table"then E:update()continue end

y(C,E,D)
end
end
end

function v:destroy()
local C=self.Parent and table.find(self.Parent.Descendants)

if C then
table.remove(self.Parent.Descendants,C)
end

table.clear(self.Descendants)
setmetatable(self,nil)
end

function v:changeRendering(C)
if self.IS_RENDERING~=C then
self.IS_RENDERING=C
self.UPDATED_OBJECTS=false
end
end

function v:new()
local C=setmetatable({
IS_RENDERING=true,
UPDATED_OBJECTS=false,
Descendants={},
Parent=self.Descendants~=nil and self or nil
},v)

if self.Descendants then
table.insert(self.Descendants,C)
end

return C
end

local C=v:new()

local D,E={}do
local F={}

local G={}do
G.ElementsTable={
Corner=function(H)
return E("UICorner",{
CornerRadius=H or UDim.new(0,8)
})
end,
Stroke=function(H,I)
return E("UIStroke",{
Color=H or Color3.fromRGB(60,60,60),
Thickness=I or 1
})
end,
Image=function(H)
return E("ImageLabel",{
Image=H or"",
BackgroundTransparency=1,
Size=UDim2.fromScale(1,1)
})
end,
Button=function()
return E("TextButton",{
Text="",
Size=UDim2.fromScale(1,1),
AutoButtonColor=false
})
end,
Padding=function(H,I,J,K)
return E("UIPadding",{
PaddingLeft=H or UDim.new(0,10),
PaddingRight=I or UDim.new(0,10),
PaddingTop=J or UDim.new(0,10),
PaddingBottom=K or UDim.new(0,10)
})
end,
ListLayout=function(H)
return E("UIListLayout",{
Padding=H or UDim.new(0,5)
})
end,
Text=function(H)
return E("TextLabel",{
BackgroundTransparency=1,
Text=H or""
})
end,
Gradient=function(H)
return E("UIGradient",{
Color=H
})
end
}

function G:Create(H,I,...)
local J=self.ElementsTable[I]

if J then
local K=J(...)
K.Parent=H
return K
end
end
end

local H={}

function H:Childs(I)
for J=1,#I do
I[J].Parent=self
end
end

function H:Elements(I)
for J,K in pairs(I)do
if type(K)=="table"then
D.SetProperties(G:Create(self,J),K)
else
G:Create(self,J,K)
end
end
end

function H:ThemeTag(I)
local J=I.OBJECTS
I.OBJECTS=nil
return(J or C):add(self,I)
end

function D:SetProperties(I)
for J,K in pairs(I)do
if H[J]then
H[J](self,K)
else
self[J]=K
end
end
end

function D:SetValues(...)
local I=self

for J,K in{...}do
local L=typeof(K)

if L=="table"then
D.SetProperties(I,K)
else
I[if L=="string"then"Name"else"Parent"]=K
end
end

return I
end

local I

function D:Draggable(J,K,L)
local M,N,O,P
local Q=K or 0.28
local R=0
local S local T=function(

T)
local U=T.Position-N
local V
R=tick()

if L then
V=L(
O.X.Scale,O.X.Offset+U.X/J.Scale,
O.Y.Scale,O.Y.Offset+U.Y/J.Scale
)
else
V=UDim2.new(
O.X.Scale,O.X.Offset+U.X/J.Scale,
O.Y.Scale,O.Y.Offset+U.Y/J.Scale
)
end
self.Position=self.Position:Lerp(V,Q)end local U=function()



while I==self do
if(tick()-R)>=1 then
S()
break
end
task.wait()
end end


local V={
[Enum.UserInputType.MouseButton1]=true,
[Enum.UserInputType.Touch]=true
}

local W={
[Enum.UserInputType.MouseMovement]=true,
[Enum.UserInputType.Touch]=true
}

u(self.InputBegan,function(X)
if A==false and I==nil and V[X.UserInputType]then
N=X.Position
O=self.Position
I=self
R=tick()
A=true

local Y;

function S()
A=false
I=nil
Y:Disconnect()
end

task.spawn(U)

Y=X.Changed:Connect(function()
if X.UserInputState==Enum.UserInputState.End then
S()
end
end)
end
end)

u(i.InputChanged,function(X)
if I==self and W[X.UserInputType]then
T(X)
end
end)
end

function D:CreateNewTemplate(J)
return D.CloneObject(F[self],J)
end

function D.new(J,...)
return D.SetValues(Instance.new(J),...)
end

E=D.new
end local F=function(

F)
if F==nil then
return{}
end

if type(F)~="function"and type(F)~="table"then
error(`Failed to get Callback: 'function', or 'table' expected, got {typeof(F)}`,2)
end

if type(F)~="function"then
local G=F[1]
local H=F[2]

F=function(I)
G[H]=I
end
end

return table.pack(F)end local G=function(


G, ...)
for H=1,#G do
task.spawn(G[H],...)
end end


local H="redz-library-v5"
local I=q:FindFirstChild(H)

if not I then
I=E("ScreenGui",H,q,{
IgnoreGuiInset=true
})
end local J=function(

J, K, L, M, ...)
local N=TweenInfo.new(M,EasingStyle or Enum.EasingStyle.Quint,...)

return j:Create(J,N,{
[K]=L
})end local K=function(


K)
local L={}
for M=1,#K do
rawset(L,K[M],true)
end
return L end


local L=K(string.split"\n\t,_:;()[]#&=!. \"'*^<>$")local M=function(

M)
return string.gsub(M:lower(),".",function(N)
return L[N]and""or N
end)end local N=function(


N)
local O,P,Q=tostring(N),"",0

for R=#O,1,-1 do
P=O:sub(R,R)..P
Q+=1

if R>1 and Q%3==0 then
P=","..P
end
end

return P end local O=function(


O)
local P="rbxassetid://"
return O:sub(1,#P)==P end local P=function(


P)
return(t.Y/450)*P end local Q=function(


Q)
local R=math.floor(Q/60)
local S=math.floor(Q/60/60)
Q=math.floor((Q-(R*60))*10)/10
R=R-(S*60)

if S>0 then
return`{S}h {R}m {math.floor(Q)}s`
elseif R>0 then
return`{R}m {math.floor(Q)}s`
else
return tostring(Q)
end end


local R={}do
local S={}
local T={}
local U={}
local V={}

local W
local X
local Y
local Z
local _
local aa
local ab
local ac
local ad
local ae

local af=""

local ag={SelectedTab=1,Minimized=false}
ag.__index=ag

local ah={}
ah.__index=ah

local ai={}
ai.__index=ai

local aj={}
aj.__index=aj

local ak={}do local al=function()

local al={}
al.__index=function(am,an)
return al[an]or rawget(ai,an)
end

return al end


local am=al()
ak.TextBox=am

local an=al()
ak.Toggle=an

local ao=al()
ak.Slider=ao

local ap=al()
ak.Dropdown=ap

local aq=al()
ak.Keybind=aq

local ar=al()
ak.Dialog=ar local as=function()


Z.Closed=true
Z.Closing=false
setmetatable(Z,nil)

Z=nil
aa.Parent=nil end local at=function()



if Z~=nil then
Z:Close()
end end


function ar:NewOption(au)
local av=au[1]or au.Name or au.Title
local aw=F(au[2]or au.Callback)

table.insert(aw,at)

assert(type(av)=="string",`"Dialog.NewOption.Name". 'string' expected, got {typeof(av)}`)

local ax=E("TextButton",{
AutoButtonColor=false,
Size=UDim2.fromScale(0.2,1),
BackgroundTransparency=1,
TextSize=10,
Text=av,
Elements={
Corner=UDim.new(1,0)
},
ThemeTag={
BackgroundColor3="Colors.Buttons.Default",
TextColor3="Colors.Text.Dark",
Font="Font.Normal"
}
})

local ay=J(ax,"BackgroundTransparency",0,0.3)
local az=J(ax,"BackgroundTransparency",1,0.3)

u(ax.MouseLeave,function()az:Play()end)
u(ax.MouseEnter,function()ay:Play()end)
u(ax.Activated,function()G(aw)end)

ax.Parent=aa.Template.Options
end

function ar:Close(au)
if self.Closed or self.Closing or Z~=self then
return nil
end

self.Closing=true

local av=J(self.TEMPLATE,"Size",self.NEW_SIZE,0.1)
av:Play()

if au then
av.Completed:Wait()
as()
else
u(av.Completed,as)
end
end

function ar.new(au,av)
return setmetatable({
TITLE_LABEL=au,
DESCRIPTION_LABEL=au,
Content=au.Text,
Title=av.Text,

Closed=false,
Closing=false,
Kind="Dialog"
},ar)
end

function ap:SetEnabled(au)
assert(type(au)=="table",`"Dropdown.SetEnabled[param 1]". 'table' expected, got {typeof(au)}`)

self.SET_ENABLED_OPTIONS(au)
end

function ap:Clear()
self.CLEAR_DROPDOWN()
end

function ap:NewOptions(...)
self:Clear()
self:Add(...)
end

function ap:GetOptionsCount()
return#self.DROPDOWN_OPTIONS
end

function ap:Remove(...)
local au={...}
assert(#au>0,"'Dropdown.Remove' requires one or more options.")

for av,aw in au do
self.REMOVE_DROPDOWN_OPTION(aw)
end
end

function ap:Add(...)
local au={...}
assert(#au>0,"'Dropdown.Add' requires one or more options.")

for av,aw in au do
self.ADD_DROPDOWN_OPTION(aw)
end
end

function ap.new(au,av,aw,ax,ay)
return setmetatable({
CALLBACKS=ay,

DESTROY_ELEMENT=av,
VISIBLE_ELEMENT=av,

TITLE_LABEL=aw,
DESCRIPTION_LABEL=ax,
Description=ax.Text,
Title=aw.Text,

Parent=au,
Kind="Dropdown"
},ap)
end

function ao:SetValue(au)
assert(type(au)=="number",`"Slider.SetValue". 'number' expected, got {typeof(au)}`)

if self.Value~=au then
self.WHEN_VALUE_CHANGED(au)
end
end

function ao.new(au,av,aw,ax,ay)
return setmetatable({
CALLBACKS=ay,

DESTROY_ELEMENT=av,
VISIBLE_ELEMENT=av,

TITLE_LABEL=aw,
DESCRIPTION_LABEL=ax,
Description=ax.Text,
Title=aw.Text,

Parent=au,
Kind="Slider"
},ao)
end

function an:SetValue(au)
assert(type(au)=="boolean",`"Toggle.SetValue". 'boolean' expected, got {typeof(au)}`)

if self.Value~=au then
self.Value=au
self.WHEN_VALUE_CHANGED(au)
end
end

function an.new(au,av,aw,ax,ay,az)
return setmetatable({
CALLBACKS=az,
WHEN_VALUE_CHANGED=ay,

DESTROY_ELEMENT=av,
VISIBLE_ELEMENT=av,

TITLE_LABEL=aw,
DESCRIPTION_LABEL=ax,
Description=ax.Text,
Title=aw.Text,

Parent=au,
Kind="Toggle"
},an)
end

function am:SetText(au)
assert(type(au)=="string",`"TextBox.SetText". 'string' expected, got {typeof(au)}`)

self.TEXTBOX.Text=au
return self
end

function am:SetPlaceholder(au)
assert(type(au)=="string",`"TextBox.SetPlaceholder". 'string' expected, got {typeof(au)}`)

self.TEXTBOX.PlaceholderText=au
return self
end

function am:CaptureFocus()
self.TEXTBOX:CaptureFocus()
return self
end

function am:Clear()
self.TEXTBOX.Text=""
return self
end

function am:SetTextFilter(au)
if au~=nil then
assert(type(au)=="function",`"TextBox.SetTextFilter[param 1]". 'function', or 'nil' expected, got {typeof(au)}`)
end

self.TEXTBOX_TEXT_FILTER=au
return self
end

function am.new(au,av,aw,ax,ay,az)
return setmetatable({
Title=av.Text,
Description=aw.Text,
DESCRIPTION_LABEL=aw,
TITLE_LABEL=av,

CALLBACKS=az,
DESTROY_ELEMENT=ax,
VISIBLE_ELEMENT=ax,

TEXTBOX=ay,
BUTTON=ax,

Parent=au,
Kind="TextBox"
},am)
end

am.Set=am.SetText
an.Set=an.SetValue
ao.Set=ao.SetValue
end local al=function(

al, am, an)
local ao=E("TextButton","Button",an,{
Size=UDim2.new(1,0,0,24),
AutoButtonColor=false,
Text="",
Elements={
Corner=UDim.new(0,6)
},
ThemeTag={
BackgroundColor3="Colors.Buttons.Default"
},
Childs={
E("TextLabel","Title",{
BackgroundTransparency=1,
Font=Enum.Font.GothamMedium,
Text=am.Title,
TextSize=10,
TextXAlignment=Enum.TextXAlignment.Left,
TextTransparency=(FirstTab and 0.3)or 0,
TextTruncate=Enum.TextTruncate.AtEnd,
ThemeTag={
TextColor3="Colors.Text.Default"
}
})
}
})

local ap=E("Frame",ao,{
Position=UDim2.new(0,1,0.5,0),
AnchorPoint=Vector2.new(0,0.5),
Size=UDim2.fromOffset(4,4),
BackgroundTransparency=1,
ThemeTag={
BackgroundColor3="Colors.Primary"
},
Elements={
Corner=UDim.new(0.5,0)
}
})

local aq=E("ScrollingFrame","Container",{
Size=UDim2.new(1,0,1,0),
Position=UDim2.new(0,0,1),
AnchorPoint=Vector2.new(0,1),
ScrollBarThickness=1.5,
BackgroundTransparency=1,
ScrollBarImageTransparency=0.2,
AutomaticCanvasSize=Enum.AutomaticSize.Y,
ScrollingDirection=Enum.ScrollingDirection.Y,
BorderSizePixel=0,
CanvasSize=UDim2.new(),
ThemeTag={
ScrollBarImageColor3="Colors.ScrollBar"
},
Elements={
Padding={
PaddingLeft=UDim.new(0,10),
PaddingRight=UDim.new(0,10),
PaddingTop=UDim.new(0,10),
PaddingBottom=UDim.new(0,10)
},
ListLayout={
Padding=UDim.new(0,5)
}
}
})

local ar=E("ImageLabel",ao,{
Position=UDim2.new(0,8,0.5),
Size=UDim2.new(0,13,0,13),
AnchorPoint=Vector2.new(0,0.5),
BackgroundTransparency=1,
ImageTransparency=0.3,
Image=am.Icon or""
})local as=function()


local as=string.sub(ar.Image,1,13)=="rbxassetid://"
local at=ao.Title
ar.Visible=as
at.Size=UDim2.new(1,as and-25 or-15,1)
at.Position=UDim2.fromOffset(as and 25 or 15)end


u(ar:GetPropertyChangedSignal"Image",as)
as()

return ao,aq,ap,ar end local am=function(


am, an, ao, ap)
local aq=E("TextLabel",{
TextXAlignment=Enum.TextXAlignment.Left,
TextTruncate=Enum.TextTruncate.AtEnd,
AutomaticSize=Enum.AutomaticSize.Y,
Size=UDim2.new(1,-20),
Position=UDim2.fromScale(0,0.5),
AnchorPoint=Vector2.new(0,0.5),
BackgroundTransparency=1,
TextSize=11,
ThemeTag={
OBJECTS=C,
TextColor3="Colors.Text.Default",
Font="Font.Medium"
}
})

local ar=V[am]
local as=T[am].Container

local at=E("TextLabel",{
TextXAlignment=Enum.TextXAlignment.Left,
AutomaticSize=Enum.AutomaticSize.Y,
Size=UDim2.new(1,-20),
Position=UDim2.new(0,12,0,15),
BackgroundTransparency=1,
TextWrapped=true,
TextSize=8,
RichText=true,
ThemeTag={
OBJECTS=ar,
TextColor3="Colors.Text.Dark",
Font="Font.Normal"
}
})

local au={
OBJECTS=ar,
BackgroundColor3="Colors.Buttons.Default"
}

local av=E("TextButton","Option",{
AutomaticSize=Enum.AutomaticSize.Y,
Size=UDim2.new(1,0,0,25),
AutoButtonColor=false,
Text="",
ThemeTag=au,
Elements={
Corner=UDim.new(0,6)
},
Childs={
E("Frame","Holder",{
AutomaticSize=Enum.AutomaticSize.Y,
BackgroundTransparency=1,
Size=ap,
Elements={
ListLayout={
SortOrder=Enum.SortOrder.LayoutOrder,
VerticalAlignment=Enum.VerticalAlignment.Center,
Padding=UDim.new(0,2)
},
Padding={
PaddingBottom=UDim.new(0,5),
PaddingTop=UDim.new(0,5)
}
},
Childs={aq,at}
})
}
})

local aw=av.Holder local ax=function(

ax, ay)
if ay then
if _ then
local az=w(s.CurrentTheme,"Colors.Buttons.Default")
_.Theme.BackgroundColor3="Colors.Buttons.Default"
J(_.Button,"BackgroundColor3",az,0.2):Play()
end

_={
Button=av,
Theme=au
}
end

au.BackgroundColor3=ax
J(av,"BackgroundColor3",w(s.CurrentTheme,ax),0.2):Play()end


u(av.MouseLeave,function()ax("Colors.Buttons.Default",false)end)
u(av.MouseEnter,function()ax("Colors.Buttons.Holding",true)end)

u(at:GetPropertyChangedSignal"Text",function()
local ay=#at.Text>0

if at.Visible~=ay then
local az=ay and 0 or 0.5
at.Visible=ay
aw.Position=UDim2.fromScale(0,az)
aw.AnchorPoint=Vector2.new(0,az)
end
end)

aq.Text=an
at.Text=ao or""

av.Parent=as

return av,aq,at end local an=function(


an, ao)
if type(ao)~="table"then
error(`"Tab.Add{an}[Configs]". 'table' expected, got {typeof(ao)}`,2)
end

local ap=ao[1]or ao.Name or ao.Title
local aq=ao.Desc or ao.Description

assert(type(ap)=="string",`"Tab.Add{an}.Title". 'string' expected, got {typeof(ap)}`)

if aq~=nil and type(aq)~="string"then
error(`"Tab.Add{an}.Description". 'string', or 'nil' expected, got {typeof(aq)}`,2)
end

return ap,aq or""end local ao=function(


ao, ap)
if ap~=nil and type(ap)~="string"then
error(`"Tab.Add{ao}.Flag". 'nil', or 'string' expected, got {typeof(ap)}`)
end

return ap end local ap=function()



local ap=160

local aq={
Corner=UDim.new(0,6),
Stroke={
ThemeTag={
Color="Colors.Stroke"
}
},
Gradient={
Rotation=45,
ThemeTag={
Color="Colors.Background"
}
}
}

local ar=E("TextButton",OutBox,{
Size=UDim2.fromScale(1,1),
BackgroundTransparency=1,
Active=true,
Text=""
})

local as=E("Frame","Dropdown",ar,{
Size=UDim2.fromOffset(ap,100),
Position=UDim2.fromOffset(50,50),
Elements=aq,
Active=true,
ThemeTag={
BackgroundTransparency="BackgroundTransparency"
}
})

local at=E("TextButton","Search",as,{
Position=UDim2.new(1,5,0,5),
Size=UDim2.new(0,25,0,25),
AutomaticSize=Enum.AutomaticSize.X,
Active=true,
Elements=aq,
Text="",
ThemeTag={
BackgroundTransparency="BackgroundTransparency"
},
Childs={
E("UIPadding",{
PaddingLeft=UDim.new(0,5),
PaddingRight=UDim.new(0,5),
PaddingBottom=UDim.new(0,5),
PaddingTop=UDim.new(0,5)
}),
E("UIListLayout",{
Padding=UDim.new(0,5),
FillDirection=Enum.FillDirection.Horizontal
}),
E("TextBox","SearchBox",{
Size=UDim2.fromScale(0,1),
Position=UDim2.fromScale(0.5,0.5),
AnchorPoint=Vector2.new(0.5,0.5),
Visible=false,
PlaceholderText="Search...",
ClearTextOnFocus=false,
Text="",
Elements={
Corner=UDim.new(0,6)
},
ThemeTag={
BackgroundColor3="Colors.Stroke",
TextColor3="Colors.Text.Default",
Font="Font.ExtraBold"
}
}),
E("ImageLabel","SearchIcon",{
Size=UDim2.fromScale(1,1),
SizeConstraint=Enum.SizeConstraint.RelativeYY,
Position=UDim2.fromScale(0.5,0.5),
AnchorPoint=Vector2.new(0.5,0.5),
BackgroundTransparency=1,
ThemeTag={
BackgroundColor3="Colors.Stroke",
ImageColor3="Colors.Icons",
Image="Icons.Search"
}
})
}
})

local au=E("ScrollingFrame",as,{
Size=UDim2.new(1,-6,1,-6),
Position=UDim2.fromScale(0.5,0.5),
AnchorPoint=Vector2.new(0.5,0.5),
ScrollBarThickness=3,
BackgroundTransparency=1,
BorderSizePixel=0,
CanvasSize=UDim2.new(),
ScrollingDirection=Enum.ScrollingDirection.Y,
AutomaticCanvasSize=Enum.AutomaticSize.Y,
Active=true,
ThemeTag={
OBJECTS=C,
ScrollBarImageColor3="Colors.ScrollBar"
},
Elements={
Padding={
PaddingLeft=UDim.new(0,8),
PaddingRight=UDim.new(0,8),
PaddingTop=UDim.new(0,5),
PaddingBottom=UDim.new(0,5)
},
ListLayout={
Padding=UDim.new(0,4)
}
}
})

local av=at.SearchIcon
local aw=at.SearchBox

local ax=130

local ay=J(as,"Size",UDim2.fromOffset(ap,0),0.2)
local az=J(aw,"Size",UDim2.new(0,ax-30,1,0),0.3)
local aA=J(aw,"Size",UDim2.new(0,0,1,0),0.2)

local aB={}
local aC=false
local aD=false
local aE
local aF
local aG
local aH
local aI

local aJ=0

local aK=25
local aL=(aK*12)+10
local aM=5 local aN=function(

aN)
local aO=I.AbsoluteSize.Y/ad.Scale
return math.min((aK*math.max(aN,0.5))+10,aL,aO/1.75)end local aO=function()



local aO=as.AbsolutePosition
local aP=as.AbsoluteSize

local aQ=Vector2.new(p.X,p.Y)

local aR=aQ.X>=aO.X and aQ.X<=(aO.X+aP.X)
local aS=aQ.Y>=aO.Y and aQ.Y<=(aO.Y+aP.Y)

return aR and aS end local aP=function(


aP, aQ)
local aR=aI.AbsolutePosition
local aS=aI.AbsoluteSize
local aT=I.AbsoluteSize
local aU=ad.Scale
local aV=aN(aP)

local aW=aT.X/aU
local aX=aT.Y/aU
local aY=aR.X/aU
local aZ=aR.Y/aU
local a_=aS.X/aU
local a0=aS.Y/aU

local a1=aZ+(a0/2)
local a2=a1-(aV/2)

local a3=aM
local a4=aX-aV-aM

local a5=math.clamp(a2,a3,a4)

local a6=Vector2.new(0,0)

if a5>(aX*0.7)then
a6=Vector2.new(0,1)
a5=math.min(a1+(aV/2),aX-aM)
end

local a7=math.clamp(
aY,
aM,
aW-as.Size.X.Offset-(aM*2)-(at.AbsoluteSize.X/aU)
)

return Vector2.new(a7,a5),a6 end local aQ=function(...)



local aQ,aR=aP(...)

as.AnchorPoint=aR
as.Position=UDim2.fromOffset(aQ.X,aQ.Y)end local aR=function()



if not aD then return end

aD=false

aw.Text=""
aA:Play()
aA.Completed:Wait()
aw.Visible=false end local aS=function()



if aD then return end

aD=true

aw.Visible=true
az:Play()

aw:CaptureFocus()

local aS=as.AbsoluteSize
local aT=I.AbsoluteSize
local aU=ad.Scale
local aV=as.AnchorPoint

local aW=ax*aU

local aX=as.AbsolutePosition.X

local aY=aX+aS.X+5+aW

if aY>aT.X-(aM*aU)then
local aZ=(aT.X-aS.X-aW-5-(aM*aU))/aU

aZ=math.max(aZ,aM)

J(as,"Position",UDim2.fromOffset(aZ,as.Position.Y.Offset),0.3):Play()
end end local aT=function(


aT)
if not aC then
aE=aT
ar.Parent=Y
return true
end end local aU=function()



if aC then return end

if aE then
aE()
aE=nil
end

task.spawn(aR)
aC=true
ay:Play()
ay.Completed:Wait()
ar.Parent=nil
aC=false end local aV=function()



if aw:IsFocused()then
aJ=tick()
return nil
end

if(tick()-aJ)>=0.3 and not aO()then
aU()
end end local aW=function()



for aW,aX in aB do
aW.Parent=nil
aB[aW]=nil
end end local aX=function(


aX, aY)
aX.Selected=aY

if aX.Instance then
local aZ=aX.Instance
local a_=aZ.TextLabel
local a0=aZ.Frame

local a1=aY and 0 or(aH and 0.8 or 1)
local a2=aY and 0 or 0.4
local a3=UDim2.fromOffset(4,aY and 14 or 4)

if aZ.Parent then
J(a0,"BackgroundTransparency",a1,0.35):Play()
J(a_,"TextTransparency",a2,0.35):Play()
J(a0,"Size",a3,0.35):Play()
else
a_.TextTransparency=a2
a0.BackgroundTransparency=a1
a0.Size=a3
end
end end local aY=function(


aY)
if aw.Visible==false or not aY then
local aZ=aG and#aG or 0
as.Size=UDim2.fromOffset(ap,aN(aZ))
return nil
end

if aY then
local aZ=aY.Instance
local a_=M(aw.Text)
aZ.Visible=#a_==0 or aY.SearchText:find(a_)~=nil

if aZ.Visible~=false then
SEARCH_RESULT_COUNT+=1
as.Size=UDim2.fromOffset(ap,aN(SEARCH_RESULT_COUNT))
end
end end local aZ=function(


aZ, a_, a0, a1)
local a2=true

if a_=="+"or a_=="-"then
a2=aZ.Selected==(a_=="+")
a0=a0:sub(2,-1)
end

return a2 and a1:find(a0,1,true)~=nil end local a_=function(


a_, a0)
local a1=E("TextButton",{
Size=UDim2.new(1,0,0,21),
AutoButtonColor=false,
Text="",
Elements={
Corner=UDim.new(0,4)
},
ThemeTag={
BackgroundColor3="Colors.Buttons.Default"
},
Childs={
E("Frame",{
Position=UDim2.new(0,1,0.5),
Size=UDim2.new(0,4,0,4),
BackgroundTransparency=1,
AnchorPoint=Vector2.new(0,0.5),
Elements={
Corner=UDim.new(0.5,0)
},
ThemeTag={
BackgroundColor3="Colors.Primary"
}
}),
E("TextLabel",{
Size=UDim2.fromScale(1,1),
Position=UDim2.fromOffset(10,0),
TextXAlignment=Enum.TextXAlignment.Left,
BackgroundTransparency=1,
TextTransparency=0.4,
Text=a_.DisplayName,
TextSize=9,
ThemeTag={
Font="Font.Bold",
TextColor3="Colors.Text.Default"
}
})
}
})

local a2=0

u(a1.Activated,function()
if(tick()-a2)<0 then return end

if ar.Parent and not aC then
a2=tick()+0.2
aF(a_)
end
end)

a_.SearchText=M(a_.DisplayName)
a_.Instance=a1

if a0 then
local a3=aw.Text

if#a3>0 then
local a4=string.sub(a3,1,1)
local a5=M(aw.Text)
a1.Visible=aZ(a_,a4,a5,a_.SearchText)
end

a1.Parent=au
aY(a_)
end

aX(a_,a_.Selected)end local a0=function(


a0)
aW()
aG=a0

for a1=1,#a0 do
local a2=a0[a1]
local a3=a2.Instance

if a3==nil then
a_(a2)
a3=a2.Instance
end

a3.Parent=au
aB[a3]=true
end

aQ(#a0)
J(as,"Size",UDim2.fromOffset(ap,aN(#a0)),0.3):Play()end local a1=function()



local a1=aw.Text
local a2=string.sub(a1,1,1)
local a3=M(a1)
local a4=#a3==0
local a5=0

for a6=1,#aG do
local a7=aG[a6]
local a8=a4 or aZ(a7,a2,a3,a7.SearchText)
a7.Instance.Visible=a8

if a8 then
a5+=1
end
end

SEARCH_RESULT_COUNT=a5
as.Size=UDim2.fromOffset(ap,aN(a5))end


u(ab:GetPropertyChangedSignal"Visible",aV)
u(ab:GetPropertyChangedSignal"Size",aV)
u(ar.MouseButton1Down,aV)
u(ar.Activated,aV)

u(at.Activated,aS)
u(aw:GetPropertyChangedSignal"Text",a1)

return table.freeze{
CreateOptionTemplate=a_,
SetOptionValue=aX,
CloseDropdown=aU,
OpenDropdown=aT,
SetOptions=a0,
Clear=aW,
SetOnClicked=function(...)
aF=...
end,
SetMultiSelect=function(...)
aH=...
end,
SetHolder=function(...)
aI=...
end
}end


local aq

local ar={"W","A","S","D","Tab","Slash","Backspace","Escape","Unknown"}
local as={"MouseButton1","MouseButton2","MouseButton3"}

local at=K({"number","string","nil","boolean","table"},true)local au=function(

au)
if aq==nil then
aq=K(Enum.KeyCode:GetEnumItems())
end

return typeof(au)=="EnumItem"and aq[au]end


function ah:GetNoSelfCall(av)
assert(type(av)=="string",`"Tab.GetNoSelfCall". 'string' expected, got {typeof(av)}`)
local aw=self[av]
assert(type(aw)=="function",`"Tab.GetNoSelfCall". '{aw}' is not a 'function'-{av}`)

return function(...)
return aw(self,...)
end
end

function ah:AddSection(av)
assert(av==nil or type(av)=="string",`"Tab.AddSection[param 1]". 'string', or 'nil' expected, got {typeof(av)}`)
av=av or""

local aw=V[self]

local ax=E("Frame","Option",T[self].Container,{
Size=UDim2.new(1,0,0,20),
BackgroundTransparency=1
})

local ay=E("TextLabel",ax,{
TextXAlignment=Enum.TextXAlignment.Left,
TextTruncate=Enum.TextTruncate.AtEnd,
Size=UDim2.new(1,-25,1,0),
Position=UDim2.new(0,5),
BackgroundTransparency=1,
TextSize=17,
Text=av,
ThemeTag={
OBJECTS=aw,
TextColor3="Colors.Text.Default",
Font="Font.Bold"
}
})

return setmetatable({
Title=av,

DESTROY_ELEMENT=ax,
VISIBLE_ELEMENT=ax,
TITLE_LABEL=ay,

Kind="Section",
Parent=self
},ai)
end

function ah:AddToggle(av)
local aw,ax=an("Toggle",av)
local ay=ao("Toggle",av[4]or av.Flag)

local az=av[2]or av.Default or false
local aA=F(av[3]or av.Callback)

if type(az)~="boolean"then
error(`"Tab.AddToggle.Default". 'boolean' expected, got {typeof(az)}`,2)
end

if ay~=nil and type(ae[ay])=="number"then
az=ae[ay]==0
end

local aB=V[self]
local aC,aD,aE=am(self,aw,ax,UDim2.new(1,-38,0,0))

local aF=E("Frame",aC,{
Size=UDim2.new(0,35,0,18),
Position=UDim2.new(1,-10,0.5),
AnchorPoint=Vector2.new(1,0.5),
Elements={
Corner=UDim.new(0.5,0)
},
ThemeTag={
OBJECTS=aB,
BackgroundColor3="Colors.Stroke"
}
})

local aG=E("Frame",aF,{
BackgroundTransparency=1,
Size=UDim2.new(0.8,0,0.8,0),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5)
})

local aH={
OBJECTS=aB,
BackgroundColor3="Colors.OnPrimary"
}

local aI=E("Frame",aG,{
Size=UDim2.new(0,12,0,12),
Position=UDim2.new(0,0,0.5),
AnchorPoint=Vector2.new(0,0.5),
Elements={
Corner=UDim.new(0.5,0)
},
ThemeTag=aH
})

local aJ=tick()
local aK=0.2
local aL={}local aM=function(

aM)
aL={}
for aN=1,#aM do
aM[aN]:Play()
aL[aN]=aM[aN]
end end local aN=function()



for aN=#aL,1,-1 do
local aO=aL[aN]
if aO.PlaybackState==Enum.PlaybackState.Playing then
aO:Cancel()
end
aL[aN]=nil
end end local aO=function(


aO)
if ay~=nil then ae[ay]=aO and 0 or 1 end
G(aA,aO)

local aP=UDim2.new(aO and 1 or 0,0,0.5,0)
local aQ=Vector2.new(aO and 1 or 0,0.5)
local aR=aO and"Colors.Primary"or"Colors.OnPrimary"
local aS=w(s.CurrentTheme,aR)

aH.BackgroundColor3=aR

if self.Selected and(tick()-aJ)>=aK then
aM{
J(aI,"Position",aP,0.25),
J(aI,"AnchorPoint",aQ,0.25),
J(aI,"BackgroundColor3",aS,0.25)
}
else
aN()
aI.Position=aP
aI.AnchorPoint=aQ
aI.BackgroundColor3=aS
end

aJ=tick()end


local aP=ak.Toggle.new(self,aC,aD,aE,aO,aA)
aP:SetValue(az)

local aQ=0

u(aC.Activated,function()
if(tick()-aQ)>=aK then
aQ=tick()
aP:SetValue(not aP.Value)
end
end)

return aP
end

function ah:AddButton(av)
local aw,ax=an("Button",av)
local ay=F(av[2]or av.Callback)
local az=av.Debounce or av.Cooldown

local aA=V[self]
local aB,aC,aD=am(self,aw,ax,UDim2.new(1,-20,0,0))

local aE=E("ImageLabel",aB,{
Size=UDim2.new(0,14,0,14),
Position=UDim2.new(1,-10,0.5),
AnchorPoint=Vector2.new(1,0.5),
BackgroundTransparency=1,
ThemeTag={
OBJECTS=aA,
Image="Icons.Button"
}
})

local aF=0

u(aB.Activated,function()
if az~=nil and(tick()-aF)<0 then return end

if az~=nil then
aF=tick()+az
end

G(ay)
end)

return setmetatable({
CALLBACKS=ay,
DESTROY_ELEMENT=aB,
VISIBLE_ELEMENT=aB,
TITLE_LABEL=aC,
DESCRIPTION_LABEL=aD,

Title=aw,
Description=ax,

Parent=self,
Kind="Button"
},ai)
end

function ah:AddTextBox(av)
local aw,ax=an("TextBox",av)
local ay=ao("TextBox",av[4]or av.Flag)

local az=av[2]or av.Default
local aA=F(av[3]or av.Callback)

local aB=av.Placeholder or av.PlaceholderText
local aC=av.ClearOnFocus or av.ClearTextOnFocus

if az~=nil and type(az)~="string"then
error(`"Tab.AddTextBox.Default". 'string', or 'nil' expected, got {typeof(az)}`,2)
end

if ay and type(ae[ay])=="string"then
az=ae[ay]
end

local aD=V[self]
local aE,aF,aG=am(self,aw,ax,UDim2.new(1,-150,0,0))

local aH=E("Frame",aE,{
Size=UDim2.new(0,150,0,18),
Position=UDim2.new(1,-10,0.5),
AnchorPoint=Vector2.new(1,0.5),
ThemeTag={
OBJECTS=aD,
BackgroundColor3="Colors.Stroke"
},
Elements={
Corner=UDim.new(0,4)
}
})

local aI=E("TextBox",aH,{
Size=UDim2.new(0.85,0,0.85,0),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
BackgroundTransparency=1,
TextScaled=true,
Active=true,
Text="",
PlaceholderText=B.TEXTBOX.PLACEHOLDER_TEXT,
ThemeTag={
OBJECTS=aD,
TextColor3="Colors.Text.Default",
Font="Font.Bold"
}
})

local aJ={
OBJECTS=aD,
Image="Icons.TextBox",
ImageColor3="Colors.Icons"
}

local aK=E("ImageLabel",aH,{
Size=UDim2.new(0,12,0,12),
Position=UDim2.new(0,-5,0.5),
AnchorPoint=Vector2.new(1,0.5),
BackgroundTransparency=1,
ThemeTag=aJ
})

if az~=nil then
aI.Text=az
end

if aC~=nil then
aI.ClearTextOnFocus=aC
end

if aB~=nil then
aI.PlaceholderText=aB
end

local aL=ak.TextBox.new(self,aF,aG,aE,aI,aA)local aM=function(

aM)
aJ.ImageColor3=aM
J(aK,"ImageColor3",w(s.CurrentTheme,aM),0.5):Play()end


if ay~=nil then
u(aI:GetPropertyChangedSignal"Text",function()
ae[ay]=aI.Text
end)
end

u(aI.Focused,function()
aM"Colors.Primary"
end)

u(aI.FocusLost,function()
aM"Colors.Icons"
local aN=aL.TEXTBOX_TEXT_FILTER

if aN then
local aO=aN(aI.Text)
if type(aO)=="string"then
aI.Text=aO
end
end

G(aA,aI.Text)
end)

u(aE.Activated,function()
aI:CaptureFocus()
end)

return aL
end

function ah:AddSlider(av)
local aw,ax=an("Slider",av)
local ay=ao("Slider",av[7]or av.Flag)

local az=av[2]or av.Min
local aA=av[3]or av.Max
local aB=av[4]or av.Increment
local aC=av[5]or av.Default
local aD=F(av[6]or av.Callback)

if aB~=nil and type(aB)~="number"then
error(`"Tab.AddSlider.Increment". 'number', or 'nil' expected, got {typeof(aB)}`,2)
end

if aC~=nil and type(aC)~="number"then
error(`"Tab.AddSlider.Default". 'number', or 'nil' expected, got {typeof(aC)}`,2)
end

assert(type(az)=="number",`"Tab.AddSlider.Min", 'number' expected, got {typeof(az)}`)
assert(type(aA)=="number",`"Tab.AddSlider.Max", 'number' expected, got {typeof(aA)}`)

local aE=V[self]
local aF=T[self].Container

local aG,aH,aI=am(self,aw,ax,UDim2.new(0.55,0,0,0))

if aC==nil then
aC=az
end

if aB==nil then
aB=1
end

if ay~=nil and type(ae[ay])=="number"then
aC=ae[ay]
end

local aJ=E("TextButton",aG,{
Size=UDim2.new(0.45,0,1,0),
Position=UDim2.new(1,0,0,0),
AnchorPoint=Vector2.new(1,0),
AutoButtonColor=false,
BackgroundTransparency=1,
Text=""
})

local aK=E("Frame",aJ,{
Size=UDim2.new(1,-20,0,6),
Position=UDim2.fromScale(0.5,0.5),
AnchorPoint=Vector2.new(0.5,0.5),
ThemeTag={
OBJECTS=aE,
BackgroundColor3="Colors.Stroke"
},
Elements={
Corner=UDim.new(0.5,0)
}
})

local aL=E("Frame",aK,{
Size=UDim2.fromScale(0,1),
BorderSizePixel=0,
ThemeTag={
OBJECTS=aE,
BackgroundColor3="Colors.Primary"
},
Elements={
Corner=UDim.new(0.5,0)
}
})

local aM=E("Frame",aK,{
Size=UDim2.new(0,6,0,12),
BackgroundColor3=Color3.fromRGB(220,220,220),
Position=UDim2.fromScale(0,0.5),
AnchorPoint=Vector2.new(0.5,0.5),
BackgroundTransparency=0.2,
Elements={
Corner=UDim.new(0,6)
}
})

local aN=E("TextLabel",aJ,{
Size=UDim2.new(0,50,0,14),
AnchorPoint=Vector2.new(1,0.5),
Position=UDim2.new(0,-10,0.5,-12),
TextScaled=true,
BackgroundTransparency=1,
Text=tostring(aC),
ThemeTag={
OBJECTS=aE,
TextColor3="Colors.Slider.SliderNumber",
Font="Font.SliderValue"
}
})

local aO=ak.Slider.new(self,aG,aH,aI,aD)
local aP=false

local aQ=function()
local aR=i:GetMouseLocation()
local aS=aK.AbsolutePosition
local aT=aK.AbsoluteSize
local aU=ad.Scale

local aV=math.clamp((aR.X-aS.X)/aT.X,0,1)
local aW=az+((aA-az)*aV)

local aX=math.floor((aW/aB)+0.5)*aB
return math.clamp(aX,az,aA),aV
end

local aY=function(aY)
local aZ=(aY-az)/(aA-az)

J(aL,"Size",UDim2.fromScale(aZ,1),0.05):Play()
J(aM,"Position",UDim2.fromScale(aZ,0.5),0.05):Play()

aN.Text=tostring(aY)
aO.Value=aY

if ay~=nil then
ae[ay]=aY
end
end

aO.WHEN_VALUE_CHANGED=aY
aY(aC)

u(aJ.InputBegan,function(aZ)
if V[aZ.UserInputType]then
aP=true
local a_,a0=aQ()

aY(a_)
J(aN,"TextTransparency",0,0.3):Play()
G(aD,a_)

local a1;a1=aZ.Changed:Connect(function()
if aZ.UserInputState==Enum.UserInputState.End then
aP=false
a1:Disconnect()
J(aN,"TextTransparency",0.5,0.3):Play()
end
end)
end
end)

u(i.InputChanged,function(aZ)
if aP and W[aZ.UserInputType]then
local a_,a0=aQ()
aY(a_)
G(aD,a_)
end
end)

return aO
end

function ah:AddDropdown(av)
local aw,ax=an("Dropdown",av)
local ay=ao("Dropdown",av[4]or av.Flag)

local az=av[2]or av.Options
local aA=av[3]or av.Default
local aB=F(av[5]or av.Callback)

if type(az)~="table"then
error(`"Tab.AddDropdown.Options". 'table' expected, got {typeof(az)}`,2)
end

if ay~=nil and type(ae[ay])=="string"then
aA=ae[ay]
end

local aC=V[self]
local aD,aE,aF=am(self,aw,ax,UDim2.new(0.55,0,0,0))

local aG=E("TextButton",aD,{
Size=UDim2.new(0.45,0,1,0),
Position=UDim2.new(1,0,0,0),
AnchorPoint=Vector2.new(1,0),
AutoButtonColor=false,
BackgroundTransparency=1,
Text=""
})

local aH=E("Frame",aG,{
Size=UDim2.new(1,-20,0,20),
Position=UDim2.fromScale(0.5,0.5),
AnchorPoint=Vector2.new(0.5,0.5),
ThemeTag={
OBJECTS=aC,
BackgroundColor3="Colors.Dropdown.Holder"
},
Elements={
Corner=UDim.new(0.25,0),
Stroke={
ThemeTag={
Color="Colors.Stroke"
}
}
}
})

local aI=E("TextLabel",aH,{
Size=UDim2.new(1,-30,1,0),
Position=UDim2.new(0,8,0,0),
BackgroundTransparency=1,
TextXAlignment=Enum.TextXAlignment.Left,
TextTruncate=Enum.TextTruncate.AtEnd,
Text=type(aA)=="string"and aA or"...",
ThemeTag={
OBJECTS=aC,
TextColor3="Colors.Text.Default",
Font="Font.Medium"
}
})

local aJ=E("ImageLabel",aH,{
Size=UDim2.fromOffset(16,16),
Position=UDim2.new(1,-10,0.5),
AnchorPoint=Vector2.new(1,0.5),
BackgroundTransparency=1,
ThemeTag={
OBJECTS=aC,
Image="Icons.Dropdown.Close",
ImageColor3="Colors.Icons"
}
})

local aK

local aL=function(
aL)
aI.Text=aL.DisplayName
aK:CloseDropdown()
G(aB,aL.Name)

if ay~=nil then
ae[ay]=aL.Name
end
end

aK=ak.Dropdown.new(self,aD,aE,aF,aB)

aK.DROPDOWN_OPTIONS={}
aK.REMOVE_DROPDOWN_OPTION=nil
aK.ADD_DROPDOWN_OPTION=nil
aK.CLEAR_DROPDOWN=nil
aK.SET_ENABLED_OPTIONS=nil

local aM=ac.CreateOptionTemplate
local aN=ac.SetOptionValue
local aO=ac.CloseDropdown
local aP=ac.OpenDropdown
local aQ=ac.SetOptions
local aR=ac.Clear

local aS={}

aK.REMOVE_DROPDOWN_OPTION=function(aT)
local aU=aS[aT]
if aU then
local aV=table.find(aK.DROPDOWN_OPTIONS,aU)

if aV then
table.remove(aK.DROPDOWN_OPTIONS,aV)
aU.Instance:Destroy()
aS[aT]=nil
aQ(aK.DROPDOWN_OPTIONS)
end
end
end

aK.ADD_DROPDOWN_OPTION=function(aT)
if aS[aT]then return end

local aU={
Name=aT,
DisplayName=aT,
Selected=false
}

aS[aT]=aU
table.insert(aK.DROPDOWN_OPTIONS,aU)
aQ(aK.DROPDOWN_OPTIONS)
end

aK.CLEAR_DROPDOWN=function()
table.clear(aK.DROPDOWN_OPTIONS)
table.clear(aS)
aR()
end

aK.SET_ENABLED_OPTIONS=function(aT)
for aU,aV in aT do
local aW=aS[aU]
if aW and aW.Instance then
aW.Instance.Visible=aV
end
end
end

ac.SetOnClicked(aL)
ac.SetMultiSelect(false)
ac.SetHolder(aH)

for aT,aU in az do
aK:Add(aU)
end

if aA then
aL{
Name=aA,
DisplayName=aA
}
end

u(aG.Activated,function()
if aO(aK)then
aJ.Image=w(s.CurrentTheme,"Icons.Dropdown.Open")
aQ(aK.DROPDOWN_OPTIONS)
else
aJ.Image=w(s.CurrentTheme,"Icons.Dropdown.Close")
aP()
end
end)

return aK
end

function ah:AddColorPicker()

end

function ah:AddKeybind(av)
local aw,ax=an("Keybind",av)
local ay=ao("Keybind",av[4]or av.Flag)

local az=av[2]or av.Default
local aA=F(av[3]or av.Callback)

if az~=nil and not au(az)then
error(`"Tab.AddKeybind.Default". 'EnumItem' expected, got {typeof(az)}`,2)
end

if ay~=nil and ae[ay]then
az=ae[ay]
end

local aB=V[self]
local aC,aD,aE=am(self,aw,ax,UDim2.new(0.55,0,0,0))

local aF=E("TextButton",aC,{
Size=UDim2.new(0.45,0,1,0),
Position=UDim2.new(1,0,0,0),
AnchorPoint=Vector2.new(1,0),
AutoButtonColor=false,
BackgroundTransparency=1,
Text=""
})

local aG=E("Frame",aF,{
Size=UDim2.new(1,-20,0,20),
Position=UDim2.fromScale(0.5,0.5),
AnchorPoint=Vector2.new(0.5,0.5),
ThemeTag={
OBJECTS=aB,
BackgroundColor3="Colors.Dropdown.Holder"
},
Elements={
Corner=UDim.new(0.25,0),
Stroke={
ThemeTag={
Color="Colors.Stroke"
}
}
}
})

local aH=E("TextLabel",aG,{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
TextXAlignment=Enum.TextXAlignment.Center,
TextTruncate=Enum.TextTruncate.AtEnd,
Text=az and az.Name or"None",
ThemeTag={
OBJECTS=aB,
TextColor3="Colors.Text.Default",
Font="Font.Medium"
}
})

local aI=E("ImageLabel",aG,{
Size=UDim2.fromOffset(16,16),
Position=UDim2.new(1,-5,0.5),
AnchorPoint=Vector2.new(1,0.5),
BackgroundTransparency=1,
ThemeTag={
OBJECTS=aB,
Image="Icons.Keybind",
ImageColor3="Colors.Icons"
}
})

local aJ=ak.Keybind.new(self,aC,aD,aE,aA)
local aK=false

aJ.Value=az

local aL=function(
aL)
aH.Text=aL.Name
aJ.Value=aL
G(aA,aL)

if ay~=nil then
ae[ay]=aL
end
end

u(aF.Activated,function()
aK=true
aH.Text="..."
end)

u(i.InputBegan,function(aM)
if aK then
if aM.UserInputType==Enum.UserInputType.Keyboard then
aK=false
aL(aM.KeyCode)
end
end
end)

return aJ
end

function aj:MakeWindow(av)
if I then I:Destroy()end

local aw=av[1]or av.Name or av.Title
local ax=av[2]or av.SubTitle or av.Description
local ay=av[3]or av.Theme or"Darker"
local az=av[4]or av.FolderToSave or"Redz Library"

local aA=s.Themes[ay]

if aA then
s.CurrentTheme=aA
else
warn(`Theme "{ay}" not found. Using default theme.`)
s.CurrentTheme=s.Themes.Darker
end

if d then
if not isfolder(az)then
d(az)
end

if not isfolder(az.."/Configs")then
d(az.."/Configs")
end

ae={}
af=az.."/Configs/"
end

local aB=E("Frame","Main",I,{
Size=s.Default.UISize,
Position=UDim2.fromScale(0.5,0.5),
AnchorPoint=Vector2.new(0.5,0.5),
ClipsDescendants=true,
Elements={
Corner=UDim.new(0,10),
Stroke={
ThemeTag={
Color="Colors.Stroke"
}
}
},
ThemeTag={
OBJECTS=C,
BackgroundColor3="Colors.Background"
}
})

local aC=E("Frame","TopBar",aB,{
Size=UDim2.new(1,0,0,45),
BackgroundTransparency=1,
Elements={
Padding={
PaddingLeft=UDim.new(0,15),
PaddingRight=UDim.new(0,15)
}
}
})

local aD=E("TextLabel","Title",aC,{
Size=UDim2.fromScale(0,1),
AutomaticSize=Enum.AutomaticSize.X,
BackgroundTransparency=1,
Text=aw,
TextXAlignment=Enum.TextXAlignment.Left,
TextSize=16,
ThemeTag={
OBJECTS=C,
TextColor3="Colors.Text.Default",
Font="Font.Bold"
}
})

local aE=E("TextLabel","SubTitle",aC,{
Size=UDim2.fromScale(0,1),
AutomaticSize=Enum.AutomaticSize.X,
Position=UDim2.new(0,aD.AbsoluteSize.X+10,0,0),
BackgroundTransparency=1,
Text=ax or"",
TextXAlignment=Enum.TextXAlignment.Left,
TextSize=12,
TextTransparency=0.4,
ThemeTag={
OBJECTS=C,
TextColor3="Colors.Text.Default",
Font="Font.Medium"
}
})

local aF=E("ImageButton","Close",aC,{
Size=UDim2.fromOffset(20,20),
Position=UDim2.new(1,0,0.5,0),
AnchorPoint=Vector2.new(1,0.5),
BackgroundTransparency=1,
AutoButtonColor=false,
ThemeTag={
OBJECTS=C,
Image="Icons.Close",
ImageColor3="Colors.Icons"
}
})

local aG=E("ImageButton","Minimize",aC,{
Size=UDim2.fromOffset(20,20),
Position=UDim2.new(1,-30,0.5,0),
AnchorPoint=Vector2.new(1,0.5),
BackgroundTransparency=1,
AutoButtonColor=false,
Image="rbxassetid://10709791437",
ThemeTag={
OBJECTS=C,
ImageColor3="Colors.Icons"
}
})

local aH=E("ScrollingFrame","TabContainer",aB,{
Size=UDim2.new(0,s.Default.TabSize,1,-65),
Position=UDim2.new(0,15,0,55),
BackgroundTransparency=1,
ScrollBarThickness=0,
CanvasSize=UDim2.new(),
AutomaticCanvasSize=Enum.AutomaticSize.Y,
ScrollingDirection=Enum.ScrollingDirection.Y,
Elements={
ListLayout={
Padding=UDim.new(0,5)
},
Padding={
PaddingBottom=UDim.new(0,10)
}
}
})

local aI=E("Frame","Container",aB,{
Size=UDim2.new(1,-s.Default.TabSize-45,1,-65),
Position=UDim2.new(1,-15,0,55),
AnchorPoint=Vector2.new(1,0),
BackgroundTransparency=1,
ClipsDescendants=true
})

D.SetProperties(aB,{
Draggable=true
})

u(aB:GetPropertyChangedSignal"Size",function()
if ag.Minimized then return end
s.Default.UISize=aB.Size
end)

u(aD:GetPropertyChangedSignal"AbsoluteSize",function()
aE.Position=UDim2.new(0,aD.AbsoluteSize.X+10,0,0)
end)

u(aF.Activated,function()
I:Destroy()
end)

local aJ=false

u(aG.Activated,function()
if aJ then return end
aJ=true

ag.Minimized=not ag.Minimized
local aK=ag.Minimized
local aL=aK and UDim2.fromOffset(s.Default.UISize.X.Offset,45)or s.Default.UISize

J(aB,"Size",aL,0.4,Enum.EasingStyle.Quart,Enum.EasingDirection.Out):Play()
J(aH,"GroupTransparency",aK and 1 or 0,0.3):Play()
J(aI,"GroupTransparency",aK and 1 or 0,0.3):Play()

task.wait(0.4)
aJ=false
end)

ad=E("UIScale",I)
ac=ao()
aa=ak.Dialog.new(aD,aE)

aa.Parent=I
aa.Template=E("Frame","Dialog",{
Size=UDim2.fromOffset(300,150),
Position=UDim2.fromScale(0.5,0.5),
AnchorPoint=Vector2.new(0.5,0.5),
ThemeTag={
OBJECTS=C,
BackgroundColor3="Colors.Dialog.Background"
},
Elements={
Corner=UDim.new(0,12),
Stroke={
ThemeTag={
Color="Colors.Stroke"
}
}
},
Childs={
E("TextLabel","Title",{
Size=UDim2.new(1,-40,0,30),
Position=UDim2.fromOffset(20,15),
BackgroundTransparency=1,
TextXAlignment=Enum.TextXAlignment.Left,
TextSize=16,
ThemeTag={
OBJECTS=C,
TextColor3="Colors.Text.Default",
Font="Font.Bold"
}
}),
E("TextLabel","Description",{
Size=UDim2.new(1,-40,1,-80),
Position=UDim2.fromOffset(20,50),
BackgroundTransparency=1,
TextXAlignment=Enum.TextXAlignment.Left,
TextYAlignment=Enum.TextYAlignment.Top,
TextSize=14,
TextWrapped=true,
ThemeTag={
OBJECTS=C,
TextColor3="Colors.Text.Default",
Font="Font.Medium"
}
}),
E("Frame","Options",{
Size=UDim2.new(1,-40,0,30),
Position=UDim2.new(0,20,1,-15),
AnchorPoint=Vector2.new(0,1),
BackgroundTransparency=1,
Elements={
ListLayout={
Padding=UDim.new(0,10),
FillDirection=Enum.FillDirection.Horizontal,
HorizontalAlignment=Enum.HorizontalAlignment.Right
}
}
})
}
})

aa.NEW_SIZE=UDim2.fromOffset(0,0)
aa.TEMPLATE=aa.Template

aa.Template.Visible=false
aa.Template.Parent=nil

ab=ac.CreateOptionTemplate{
DisplayName="Dropdown",
Selected=false
}.Instance.Parent.Parent.Parent.Parent

ab.Parent=I

local aM={}

function aM:AddTab(aN,aO)
local aP=al(aN,aH)
local aQ=setmetatable({
Title=aN,
Icon=aO,

Parent=self,
Container=aP[2],
Button=aP[1],
Hover=aP[3],
IconImage=aP[4],
Kind="Tab"
},ah)

local aR=function()
if ag.SelectedTab==aQ then return end
local aS=ag.SelectedTab

if aS then
J(aS.Hover,"Size",UDim2.fromOffset(4,4),0.2):Play()
J(aS.Hover,"BackgroundTransparency",1,0.2):Play()
J(aS.Button.Title,"TextTransparency",0.3,0.2):Play()
J(aS.IconImage,"ImageTransparency",0.3,0.2):Play()
aS.Container.Visible=false
end

ag.SelectedTab=aQ

J(aQ.Hover,"Size",UDim2.new(0,4,0,14),0.2):Play()
J(aQ.Hover,"BackgroundTransparency",0,0.2):Play()
J(aQ.Button.Title,"TextTransparency",0,0.2):Play()
J(aQ.IconImage,"ImageTransparency",0,0.2):Play()
aQ.Container.Visible=true
end

if FirstTab then
FirstTab=false
ag.SelectedTab=aQ

aQ.Hover.Size=UDim2.new(0,4,0,14)
aQ.Hover.BackgroundTransparency=0
aQ.Button.Title.TextTransparency=0
aQ.IconImage.ImageTransparency=0
aQ.Container.Visible=true
else
aQ.Container.Visible=false
end

u(aQ.Button.Activated,aR)

aP[2].Parent=aI
return aQ
end

function aM:Dialog(aN)
assert(type(aN)=="table",`"Window.Dialog". 'table' expected, got {typeof(aN)}`)

if Z then
Z:Close()
end

Z=aa.new(aN,aa.Title)
Z.NEW_SIZE=UDim2.fromOffset(300,math.min(Z.Content.TextBounds.Y+95,250))

aa.Title.Text=aN.Title or"Dialog"
aa.Content.Text=aN.Text or"Dialog Description"

for aO,aP in aa.Template.Options:GetChildren()do
if aP:IsA"GuiObject"then
aP:Destroy()
end
end

if aN.Options then
for aO,aP in aN.Options do
Z:NewOption(aP)
end
end

aa.Template.Size=UDim2.new()
aa.Template.Visible=true
aa.Template.Parent=I

J(aa.Template,"Size",Z.NEW_SIZE,0.2):Play()

return Z
end

function aM:Minimize()
if aG then
local aN=aG.Activated
if aN then
aN:Fire()
end
end
end

function aM:SetScale(aN)
assert(type(aN)=="number",`"Window.SetScale". 'number' expected, got {typeof(aN)}`)
ad.Scale=math.clamp(aN,B.MIN_SCALE,B.MAX_SCALE)
end

function aM:Destroy()
if I then
I:Destroy()
end
end

return aM
end

FirstTab=true
return aj
end

return s
