import { LightningElement, api } from 'lwc';

/**
 * Stencil class for `c-stencil` component.
 * @extends {LightningElement}
 */
export default class Stencil extends LightningElement {
  /**
   * The height to set on the stencil to rendered.
   * @type {number}
   * @access public
   * @default 10
   */
  @api height = 10;

  /**
   * The width to set on the stencil to render.
   * @type {number}
   * @access public
   */
  @api width;

  /**
   * Whether the stencil should render with a circular shape.
   * @type {boolean}
   * @access public
   * @default false
   */
  @api circle = false;

  /**
   * The amount of stencil containers to create.
   * @type {number}
   * @access public
   * @default 1
   */
  @api count = 1;

  /**
   * The shade in which the stencil will be rendered.
   * Possible values are `light`, `medium` or `dark`.
   * @type {string}
   * @access public
   * @default medium
   */
  @api weightVariant = 'medium';

  get containerStyle() {
    return `${this.containerHeight}; ${this.containerWidth}; ${this.containerRadius}`;
  }

  get containerHeight() {
    return `height: ${this.height}px`;
  }

  get containerWidth() {
    if (!this.width) {
      return 'width: 100%';
    }

    return `width: ${this.width}px`;
  }

  get containerRadius() {
    if (!this.circle) {
      return 'border-radius: 0.25rem';
    }

    return 'border-radius: 50%';
  }

  get items() {
    let itemArray = [];
    for (let i = 0; i < this.count; i++) {
      itemArray.push(i.toString());
    }

    return itemArray;
  }

  get loadingBackgroundColor() {
    if (this.weightVariant === 'light') {
      return 'background-color: #f3f2f2';
    }

    if (this.weightVariant === 'medium') {
      return 'background-color: #e2e2e2';
    }

    if (this.weightVariant === 'dark') {
      return 'background-color: #ccc';
    }
  }
}