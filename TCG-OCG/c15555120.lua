--ハイ・スピード・リレベル
function c15555120.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c15555120.cost)
	e1:SetTarget(c15555120.target)
	e1:SetOperation(c15555120.activate)
	c:RegisterEffect(e1)
end
c15555120.check=false
function c15555120.cfilter(c,tp)
	local lv=c:GetLevel()
	if lv<=0 or not c:IsSetCard(0x2016) or not c:IsType(TYPE_MONSTER) or not c:IsAbleToRemoveAsCost()
		or not Duel.IsExistingTarget(c15555120.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,lv) then return false end
	if Duel.IsPlayerAffectedByEffect(c:GetControler(),69832741) then
		return c:IsFaceup() and c:IsLocation(LOCATION_MZONE)
	else
		return c:IsLocation(LOCATION_GRAVE)
	end
end
function c15555120.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	c15555120.check=true
	if chk==0 then return true end
end
function c15555120.filter(c,lv)
	local clv=c:GetLevel()
	return c:IsFaceup() and clv>0 and clv~=lv and c:IsType(TYPE_SYNCHRO)
end
function c15555120.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local lv=e:GetLabel()
		return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c15555120.filter(chkc,lv) end
	if chk==0 then
		if not c15555120.check then return false end
		c15555120.check=false
		return Duel.IsExistingMatchingCard(c15555120.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c15555120.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	local lv=g:GetFirst():GetLevel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c15555120.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,lv)
	e:SetLabel(lv)
end
function c15555120.activate(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetLabel()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:GetLevel()~=lv then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(lv*500)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end
