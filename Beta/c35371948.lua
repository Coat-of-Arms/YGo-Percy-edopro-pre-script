--トリックスター・ライトステージ
--Trickster Lightstage
--Scripted by Eerie Code
function c35371948.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c35371948.activate)
	c:RegisterEffect(e1)
	--lock
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(35371948,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c35371948.target)
	e2:SetOperation(c35371948.operation)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetCondition(c35371948.damcon1)
	e3:SetOperation(c35371948.damop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_DAMAGE)
	e4:SetCondition(c35371948.damcon2)
	c:RegisterEffect(e4)
end
function c35371948.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xfb) and c:IsAbleToHand()
end
function c35371948.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c35371948.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(35371948,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c35371948.cfilter(c)
	return c:IsFacedown() and c:GetSequence()<5
end
function c35371948.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_SZONE) and c35371948.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c35371948.cfilter,tp,0,LOCATION_SZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(35371948,2))
	local g=Duel.SelectTarget(tp,c35371948.cfilter,tp,0,LOCATION_SZONE,1,1,e:GetHandler())
end
function c35371948.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsFacedown() and tc:IsRelateToEffect(e) then
		c:SetCardTarget(tc)
		e:SetLabelObject(tc)
		tc:RegisterFlagEffect(35371948,RESET_EVENT+0x1fe0000,0,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DRAW)
		e1:SetCondition(c35371948.rcon)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
		--Activate or send
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetRange(LOCATION_FZONE)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DRAW)
		e2:SetLabelObject(tc)
		e2:SetOperation(c35371948.agop)
		c:RegisterEffect(e2)
	end
end
function c35371948.tcost(cost,typea,code,property,te)
	return function (e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (not cost or cost(te,te:GetHandlerPlayer(),eg,ep,ev,re,r,rp,0)) end
		te:SetType(typea)
		te:SetCode(code)
		te:SetProperty(property)
		te:GetHandler():CreateEffectRelation(te)
		Duel.ChangePosition(te:GetHandler(),POS_FACEUP)
		if cost then
			te:SetCost(cost)
			cost(te,te:GetHandlerPlayer(),eg,ep,ev,re,r,rp,1)
		end
	end
end
function c35371948.ttarget(target,te)
	return function (e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return target(te,te:GetHandlerPlayer(),eg,ep,ev,re,r,rp,0) end
		te:SetTarget(target)
		target(te,te:GetHandlerPlayer(),eg,ep,ev,re,r,rp,1)
	end
end
function c35371948.top(operation,te)
	return function (e,tp,eg,ep,ev,re,r,rp)
		te:SetOperation(operation)
		operation(te,te:GetHandlerPlayer(),eg,ep,ev,re,r,rp)
	end
end
function c35371948.rcon(e)
	return e:GetOwner():IsHasCardTarget(e:GetHandler()) and e:GetHandler():GetFlagEffect(35371948)~=0
end
function c35371948.agop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if not tc or tc:IsFaceup() or not tc:IsLocation(LOCATION_SZONE) then return end
	tc:ResetFlagEffect(35371948)
	local act=true
	local te=tc:GetActivateEffect()
	local tep=tc:GetControler()
	local condition=nil
	local cost=nil
	local target=nil
	local operation=nil
	if te then
		condition=te:GetCondition()
		cost=te:GetCost()
		target=te:GetTarget()
		operation=te:GetOperation()
		act=te:GetCode()==EVENT_FREE_CHAIN and te:IsActivatable(tep)
			and (not condition or condition(te,tep,eg,ep,ev,re,r,rp))
			and (not cost or cost(te,tep,eg,ep,ev,re,r,rp,0))
			and (not target or target(te,tep,eg,ep,ev,re,r,rp,0))
	end
	local op=0
	if act then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPTION)
		op=Duel.SelectOption(tep,aux.Stringid(35371948,3),aux.Stringid(35371948,4))
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPTION)
		op=Duel.SelectOption(tep,aux.Stringid(35371948,4))+1
	end
	if op==0 then
		Duel.ClearTargetCard()
		local typea=te:GetType()
		local code=te:GetCode()
		local property=te:GetProperty()
		te:SetType(EFFECT_TYPE_TRIGGER_F)
		te:SetCost(c35371948.tcost(cost,typea,code,property,te))
		if target then 
			te:SetTarget(c35371948.ttarget(target,te))
		end
		if operation then 
			te:SetOperation(c35371948.top(operation,te))
		end
		if not te:IsHasProperty(EFFECT_FLAG_SET_AVAILABLE)then
		te:SetProperty(property+EFFECT_FLAG_SET_AVAILABLE)
		end
	else
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
function c35371948.damcon1(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and eg:GetFirst():IsSetCard(0xfb)
end
function c35371948.damcon2(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and bit.band(r,REASON_BATTLE)==0 and re 
		and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0xfb)
end
function c35371948.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,35371948)
	Duel.Damage(1-tp,200,REASON_EFFECT)
end