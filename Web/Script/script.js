const btn1=document.getElementById("btnStandard");
const btn2=document.getElementById("btnMetric");
const calculateWeight=document.getElementById("weightLogic");
const calculateHeight=document.getElementById("heightLogic");
function cickBtn(btn){
    btn.style.color = 'red';
    logic(btn);
    if (btn === btn1) {
        btn2.style.color = 'black';
        
    } else {
        btn1.style.color = 'black';
    }
}
function logic(btn){
    if (btn === btn1) {
        calculateWeight.innerHTML='<label for=""><input type="number" placeholder="pounds" required>pounds</label>'
        calculateHeight.innerHTML='<label for=""><input type="number" max="9" min="1" placeholder="feet" required>feet</label><label for=""><input type="number" max="9" min="1" placeholder="inch" required>inches</label>'
    } else {
        calculateWeight.innerHTML='<label for=""><input type="number" placeholder="kg" required>Kilogram</label>'
        calculateHeight.innerHTML='<label for=""><input type="number" placeholder="cm" required>cm</label>'
    }

}

