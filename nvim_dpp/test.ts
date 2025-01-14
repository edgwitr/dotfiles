// AとBが排他的で、C,D,Eがオプショナルな型定義
type BaseOptionalFields = {
  C?: string;
  D?: number;
  E?: boolean;
}

type WithA = {
  A: string;
  B?: never;
} & BaseOptionalFields;

type WithB = {
  A?: never;
  B: number;
} & BaseOptionalFields;

// AまたはBのどちらかを必須とする型
type ExclusiveRequiredFields = WithA | WithB;

// 使用例
const validWithA: ExclusiveRequiredFields = {
  A: "value",  // Aを指定
  C: "optional", // オプショナルフィールド
  E: true      // オプショナルフィールド
};

const validWithB: ExclusiveRequiredFields = {
  B: 123,      // Bを指定
  D: 456       // オプショナルフィールド
};

// コンパイルエラーになる例
const invalid: ExclusiveRequiredFields = {
  A: "value",
  B: 123  // AとBを同時に指定するとエラー
};
