loadstring(game:HttpGet(("https://raw.githubusercontent.com/Msunehub/Ui1/refs/heads/main/RedTT2.lua")))()

       local Window = MakeWindow({
         Hub = {
         Title = "Matsune Hub",
         Animation = "By: Dragon Toro"
         }
      })

       MinimizeButton({
       Image = "http://www.roblox.com/asset/?id=122789004227770",
       Size = {45, 45},
       Color = Color3.fromRGB(10, 10, 10),
       Corner = true,
       Stroke = false,
       StrokeColor = Color3.fromRGB(255, 0, 0)
      })
      
------ Tab
     local Tab1o = MakeTab({Name = "Tab 1"})
     local Tab2o = MakeTab({Name = "Tab 2"})
     local Tab3o = MakeTab({Name = "Tab3"})
     
     
-------TOGGLE 

     Toggle = AddToggle(Tab1o, {
      Name = "Toggle Test",
      Default = false,
      Callback = function()
     end
    })
    
------- BUTTON
    
    AddButton(Tab1o, {
     Name = "button Tesst",
    Callback = function()
  end
  })
  
----- Dropdown 

  Dropdown = AddDropdown(Tab1o, {
     Name = "Select Tesst",
     Options = {"Test 1", "Test 2", "Test 3", "Test 4"},
     Default = "Melee",
     Callback = function()
     end
   })

----- Section 
   
   Section = AddSection(Tab1o, {"Section  Test"})          

----- Paragraph 
                    
   Paragraph = AddParagraph(Farm, {"Paragraph Test", ""})
   
----- Slider 

    local mobmau = AddSlider(Tab1o, {
     Name = "Test",
     MinValue = 0,
     MaxValue = 100,
     Default = 85,
     Increase = 1,
     Callback = function()
     end
    })   
    
    local TextBox = AddTextBox(Tab1o, {
    Name = "Test",
    Default = "",
   PlaceholderText = "",
   Callback = function()
 end
 })
