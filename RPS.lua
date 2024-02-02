local NPC_ID = 900900

function OnGossipHello(event, player, object)
    player:GossipClearMenu()
    player:GossipMenuAddItem(0, "Would you like to play Rock-Paper-Scissors?", 0, 1)
    player:GossipSendMenu(1, object, 100)
end

function OnGossipSelect(event, player, object, sender, intid, code)
    player:GossipClearMenu()

    if intid == 1 then
        player:GossipMenuAddItem(0, "Rock", 0, 2)
        player:GossipMenuAddItem(0, "Paper", 0, 3)
        player:GossipMenuAddItem(0, "Scissors", 0, 4)
        player:GossipSendMenu(1, object, 100)
    elseif intid >= 2 and intid <= 4 then
        local choices = {"Rock", "Paper", "Scissors"}
        local npcChoice = choices[math.random(1, 3)]
        local playerChoice = choices[intid - 1]

        player:SendBroadcastMessage("You chose " .. playerChoice .. ".")
        player:SendBroadcastMessage("NPC chose " .. npcChoice .. ".")

        local result = DetermineWinner(playerChoice, npcChoice)

        if result == "win" then
            player:SendBroadcastMessage("Congratulations! You win!")
            player:AddMoney(1000)  -- Assuming the currency is in copper, 1000 copper = 10 gold
        elseif result == "lose" then
            player:SendBroadcastMessage("Sorry, you lose. Better luck next time!")
            player:RemoveMoney(1000)  -- Assuming the currency is in copper, 1000 copper = 10 gold
        else
            player:SendBroadcastMessage("It's a tie! Play again.")
        end

        player:GossipComplete()
    end
end

function DetermineWinner(playerChoice, npcChoice)
    if playerChoice == npcChoice then
        return "tie"
    elseif (playerChoice == "Rock" and npcChoice == "Scissors") or
           (playerChoice == "Paper" and npcChoice == "Rock") or
           (playerChoice == "Scissors" and npcChoice == "Paper") then
        return "win"
    else
        return "lose"
    end
end

RegisterCreatureGossipEvent(NPC_ID, 1, OnGossipHello)
RegisterCreatureGossipEvent(NPC_ID, 2, OnGossipSelect)
