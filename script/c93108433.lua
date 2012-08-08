--モンスター回収
function c93108433.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c93108433.target)
	e1:SetOperation(c93108433.activate)
	c:RegisterEffect(e1)
end
function c93108433.mfilter(c,tp)
	return c:IsAbleToDeck() and tp==c:GetOwner()
end
function c93108433.hfilter(c,tp)
	return tp~=c:GetOwner()
end
function c93108433.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c93108433.filter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp)
		and Duel.IsExistingTarget(c93108433.mfilter,tp,LOCATION_MZONE,0,1,e:GetHandler(),tp) 
		and not Duel.IsExistingMatchingCard(c93108433.hfilter,tp,LOCATION_HAND,0,1,nil,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectTarget(tp,c93108433.mfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	local g2=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,g1:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,g2,g2:GetCount(),0,0)
end
function c93108433.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local g2=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local tc=g1:GetFirst()
	if tc:IsRelateToEffect(e) then 
		if g2:GetCount()==0 then return end
		Duel.SendtoDeck(g1,nil,2,REASON_EFFECT)
		Duel.SendtoDeck(g2,nil,2,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.Draw(tp,g2:GetCount(),REASON_EFFECT)
	 end 
end
