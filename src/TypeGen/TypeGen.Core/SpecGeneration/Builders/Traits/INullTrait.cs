namespace TypeGen.Core.SpecGeneration.Builders.Traits;

internal interface INullTrait<TSpecBuilder>
{
    /// <summary>
    /// Marks the selected member as null (equivalent of TsNullAttribute).
    /// </summary>
    /// <returns>The current instance of <typeparamref name="TSpecBuilder"/>.</returns>
    TSpecBuilder Null();
}