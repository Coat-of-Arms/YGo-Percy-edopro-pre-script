-- Hero's Rule 1: Five Freedoms
-- scripted by: UnknownGuest
function c810000005.initial_effect(c)
	-- Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c810000005.target)
	e1:SetOperation(c810000005.activate)
	c:RegisterEffect(e1)
end
function c810000005.rmfilter(c)
	if not c:IsAbleToRemove() then return false end
	if c:IsLocation(LOCATION_GRAVE) then
		return not Duel.IsPlayerAffectedByEffect(c:GetControler(),69832741) or not c:IsType(TYPE_MONSTER)
	else
		return Duel.IsPlayerAffectedByEffect(c:GetControler(),69832741)
	end
end
function c810000005.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and c810000005.rmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c810000005.rmfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,5,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c810000005.rmfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,5,5,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,5,0,0)
end
function c810000005.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end