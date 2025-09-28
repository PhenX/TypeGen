namespace TypeGen.Core.SpecGeneration.Builders.Traits;

internal interface ICustomBodyTrait<TSpecBuilder>
{
    /// <summary>
    /// Indicates type has a custom body (equivalent of TsExportAttribute's CustomBody).
    /// </summary>
    /// <returns>The current instance of <typeparamref name="TSpecBuilder"/>.</returns>
    TSpecBuilder CustomBody(string body);
}
