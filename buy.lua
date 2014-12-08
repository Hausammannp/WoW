if not f then
   f=CreateFrame("Frame","f",nil);
   f:SetScript("OnEvent",
      function()
         toBuyItems = {};
         SentItemBuyRequest=nil;
      end
   );
   f:RegisterEvent("AUCTION_ITEM_LIST_UPDATE")
end


itemTable = {}
itemTable[0] = "Fireweed";
itemTable[1] = "Frostweed";
itemTable[2] = "Gorgrond Flytrap";
itemTable[3] = "Nagrand Arrowbloom";
itemTable[4] = "Starflower";
itemTable[5] = "Talador Orchid";


lastScan = 1;
currPage = 0;

curritemTableIteration = 0;
currItemName = "Nagrand Arrowbloom";

SingleItemValue = 15000;

function ah_buyCheap()
   -- sind schon items in der warteschlange?
   local numItemsOnPage = GetNumAuctionItems("list")
   for n=lastScan,numItemsOnPage do
      lastScan = lastScan+1;
      local item = GetAuctionItemLink("list", n)
      if item then
         local itemName, itemLink, itemRarity,
         itemLevel, itemMinLevel, itemType,
         itemSubType, itemStackCount, itemEquipLoc,
         itemTexture, itemSellPrice = GetItemInfo(item)
         
         local auctionName, auctionTexture, auctionCount, auctionquality, auctioncanUse, auctionlevel, levelColHeader, minBid, minIncrement,
         buyoutPrice, bidAmount, highBidder, highBidderFullName, owner, ownerFullName,
         saleStatus, itemId, hasAllInfo = GetAuctionItemInfo("list", n);
         
         local actAuctionSellPrice = buyoutPrice;
         if(itemLevel >= 100 and itemSubType == 'Herb' and owner ~= 'Tobimaxit') then
            if buyoutPrice > 0 then
               if (buyoutPrice <= auctionCount*SingleItemValue) then               
                  print("buying"..auctionCount.."x "..item.." for "..GetCoinTextureString(buyoutPrice))
                  PlaceAuctionBid("list", n, buyoutPrice)
                  SentItemBuyRequest = true;
                  return;
               end
            end
         end
      end
   end
   local ccdTmp, ccdDump = CanSendAuctionQuery()  
   if ccdTmp then
      if not SentItemBuyRequest then
         if numItemsOnPage == 0 then
            ah_shiftItem();
         else
            ah_shiftToNextPage()
         end     
         ah_reloadAH()
      end
   end
end

function ah_shiftItem()
   currPage = 0;
   if(curritemTableIteration >= 5) then
      curritemTableIteration = 0
   else
      curritemTableIteration = curritemTableIteration+1;
   end
   currItemName = itemTable[curritemTableIteration]
   print("new Item" .. currItemName);
end

function ah_shiftToNextPage()
   lastScan= 1;
   currPage = currPage + 1;
end

function ah_reloadAH()
   print(currItemName, currPage);
   QueryAuctionItems(currItemName, 0, 0, 0, 0, 0, currPage, 0, 0, 0)
end