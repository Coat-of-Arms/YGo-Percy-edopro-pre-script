--Tachyon Drive
function c511001486.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c511001486.target)
	e1:SetOperation(c511001486.activate)
	c:RegisterEffect(e1)
	if not c511001486.global_check then
		c511001486.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c511001486.archchk)
		Duel.RegisterEffect(ge2,0)
	end
end
function c511001486.archchk(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(0,420)==0 then 
		Duel.CreateToken(tp,420)
		Duel.CreateToken(1-tp,420)
		Duel.RegisterFlagEffect(0,420,0,0,0)
	end
end
function c511001486.filter(c)
	return c:IsFaceup() and c:IsTachyonDragon()
end
function c511001486.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c511001486.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c511001486.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c511001486.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c511001486.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(c511001486.efilter)
		tc:RegisterEffect(e1)
	end
end
function c511001486.efilter(e,re,rp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and re:GetOwner()~=e:GetOwner()
end
