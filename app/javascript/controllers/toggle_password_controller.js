import { Controller } from "@hotwired/stimulus";
import { buildIcon, eyeClosedIcon, eyeIcon } from "../utils/icons";

export default class TogglePasswordController extends Controller {
  static targets = ['input'];

  toggle(event) {
    if( this.inputTarget.type == 'password') {
      this.inputTarget.type = 'text'
      event.currentTarget.replaceChildren(buildIcon(eyeClosedIcon))
    } else {
      this.inputTarget.type = 'password'
      event.currentTarget.replaceChildren(buildIcon(eyeIcon))
    }
  }
}
