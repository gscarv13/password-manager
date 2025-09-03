import { Controller } from "@hotwired/stimulus";
import { buildIcon, checkIcon, clipBoardIcon } from "../utils/icons";

export default class ClipboardController extends Controller {
  async copy({ params: { content } }) {
    try {
      await navigator.clipboard.writeText(content)
      this.element.replaceChildren(buildIcon(checkIcon))

      setTimeout(() => {
        this.element.replaceChildren(buildIcon(clipBoardIcon))
      }, 1000)
    } catch (e) {
      console.error('failed to copy')
    }
  }
}
