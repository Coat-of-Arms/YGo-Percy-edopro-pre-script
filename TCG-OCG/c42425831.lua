--雷遁封印式
function c42425831.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCost(c42425831.cost)
	e1:SetTarget(c42425831.target)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetDescription(aux.Stringid(42425831,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCost(c42425831.rmcost)
	e2:SetTarget(c42425831.rmtg)
	e2:SetOperation(c42425831.rmop)
	c:RegisterEffect(e2)
end
function c42425831.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function c42425831.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local label=e:GetLabel()
	if chkc then return c42425831.rmtg(e,tp,eg,ep,ev,re,r,rp,0,chkc) end
	if chk==0 then
		if label==1 then e:SetLabel(0) end
		return true
	end
	if (label~=1 or c42425831.rmcost(e,tp,eg,ep,ev,re,r,rp,0)) and c42425831.rmtg(e,tp,eg,ep,ev,re,r,rp,0) 
		and Duel.SelectYesNo(tp,aux.Stringid(42425831,1)) then
		e:SetCategory(CATEGORY_REMOVE)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e:SetOperation(c42425831.rmop)
		if label==1 then
			c42425831.rmcost(e,tp,eg,ep,ev,re,r,rp,1)
		end
		c42425831.rmtg(e,tp,eg,ep,ev,re,r,rp,1)
	else
		e:SetCategory(0)
		e:SetProperty(0)
		e:SetOperation(nil)
	end
end
function c42425831.cfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WIND) and c:IsAbleToDeckAsCost()
end
function c42425831.rmfilter(c)
	if not c:IsAbleToRemove() then return false end
	if c:IsLocation(LOCATION_GRAVE) then
		return not Duel.IsPlayerAffectedByEffect(c:GetControler(),69832741) or not c:IsType(TYPE_MONSTER)
	else
		return Duel.IsPlayerAffectedByEffect(c:GetControler(),69832741)
	end
end
function c42425831.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c42425831.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local cg=Duel.SelectMatchingCard(tp,c42425831.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoDeck(cg,nil,1,REASON_COST)
end
function c42425831.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and chkc:IsControler(1-tp) and c42425831.rmfilter(chkc) end
	if chk==0 then return e:GetHandler():GetFlagEffect(42425831)==0
		and Duel.IsExistingTarget(c42425831.rmfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c42425831.rmfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	e:GetHandler():RegisterFlagEffect(42425831,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c42425831.rmop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not g or g:GetCount()==0 then return end
	local rg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
end
