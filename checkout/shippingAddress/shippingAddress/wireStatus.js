export class WireStatus {
    #_selfTriggered;
    #_triggerCount;

    constructor(selfTriggered = false, triggerCount = 0) {
      this._selfTriggered = selfTriggered;
      this._triggerCount = triggerCount;
    }
    get triggerCount () {
        return this._triggerCount;
    }

    set triggerCount (value) {
        this._triggerCount = value;
    }

    get selfTriggered() {
        return this._selfTriggered;
    }

    set selfTriggered (value) {
        this._selfTriggered = value;
    }

    increment(){
        this._triggerCount = this._triggerCount + 1;
    }

    reset() {
        this._selfTriggered = false;
        this._triggerCount = 0;
    }
  }