// see https://github.com/VadimDez/ng2-pdf-viewer/pull/1161#issuecomment-2521857488
// type SetIterator<T> = Iterator<T>

// Keep any other type definitions that might be needed
declare module '*.svg' {
  const content: any;
  export default content;
}

declare module '*.png' {
  const content: any;
  export default content;
}
